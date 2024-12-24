import os
from argparse import ArgumentParser
from pathlib import Path
from shutil import copy
from edalize import *
from edalize import edatool

import yaml
import glob
#   pnr: '' # quartus/dse/none

def main():
    parser = ArgumentParser()
    parser.add_argument("-m","--mode",dest="mode",help="Mode to compile sim (complies _tb file), build-intel, or build-amd",default="sim")
    parser.add_argument("-c","--configure-only",dest="config_only",help="Do not build, only configure the project",action="store_true")
    parser.add_argument("-p","--program",dest="pgm",help="Do not build, only configure the project",action="store_true")
    args = parser.parse_args()
    config_only = args.config_only
    pgm = args.pgm
    mode = args.mode
    print(mode)


    with open('./config/config.yml', 'r') as config_file:
        config_data = yaml.safe_load(config_file)

    project_options = config_data['project']
    build_dir = project_options['build_dir']

    pre_built_files_vhdl = glob.glob(os.path.join(config_data['pre_built_compontents']['location'], "*.vhd"))
    pre_built_testbenches_vhdl = glob.glob(os.path.join(config_data['pre_built_compontents']['location'], "testbenches/*.vhd"))

    src_files = glob.glob(os.path.join('./src', "*.vhd")) + glob.glob(os.path.join('./src', "*.sv")) + glob.glob(os.path.join('./src', "*.v"))
    src_testbench_files = glob.glob(os.path.join('./src', "testbenches/*.vhd"))

    toplevel = project_options['top_level']
    tool = ''

    edam = {
        'files': [],
        'name': project_options['name'],
        'toplevel': toplevel,
        'tool_options': {}
    }

    bDir = ''

    if mode == "sim":   
        # TODO: Add command line switch for quartus or xsim
        toplevel = toplevel + "_tb"
        edam['toplevel'] = toplevel
        bDir = build_dir + "\\sim"
        if project_options['sim_tool'] == 'xsim':
            tool = 'xsim'
            edam['tool_options']['xsim'] = {}
            edam['tool_options']['xsim']['xelab_options'] = ["-debug typical"]
            xsim_config_tcl = "config/xsim_cfg_" + toplevel + ".tcl"
            if not Path(xsim_config_tcl).is_file():
                f = open("./config/xsim_cfg.tcl","w")
                f.writelines([
                     "log_wave -recursive *\n",
                     "create_wave_config\n",
                     "add_wave *\n",
                     "save_wave_config " + toplevel + ".wcfg\n",
                     "run all\n",
                     "exit"
                ])
                f.close()
                print("Using default xsim log script")
                xsim_config_tcl = "../../config/xsim_cfg.tcl"
            else:
                 xsim_config_tcl = "../../" + xsim_config_tcl;
            edam['tool_options']['xsim']['xsim_options'] = ["--wdb " + "./" + toplevel + '.wdb', "--tclbatch " + xsim_config_tcl]
            # TODO: Copy output file after running tool
        else: 
            print("Sim tool not yet supported")
            exit(0)
    elif mode == "build-intel":
        if project_options['synth_tool'] == 'quartus':
            tool = 'quartus'
            bDir = build_dir + "\\synth-intel"
            edam['tool_options']['quartus'] = {}
            edam['tool_options']['quartus']['family'] = config_data['device_settings_intel']['family']
            edam['tool_options']['quartus']['device'] = config_data['device_settings_intel']['device']
            edam['tool_options']['quartus']['cable'] = config_data['device_settings_intel']['cable']
            edam['tool_options']['quartus']['board_device_index']= config_data['device_settings']['board_device_index']
            if pgm:
                edam['tool_options']['quartus']['pgm'] = 'quartus'
            else:
                edam['tool_options']['quartus']['pgm'] = 'none'
        else:
            print("Synthesis tool not yet supported")
            exit(0)
    elif mode == "build-amd":
        # TODO: Find out why source files are not added to vivado or manually add them  
        # TODO: Possibly delete .bit to force recompile
        if project_options['synth_tool'] == 'vivado':
            tool = 'vivado'
            bDir = build_dir + "\\synth-amd"
            edam['tool_options']['vivado'] = {}
            edam['tool_options']['vivado']['part'] = config_data['device_settings_amd']['part']
            edam['tool_options']['vivado']['synth'] = config_data['device_settings_amd']['synth']
            # edam['tool_options']['vivado']['part'] = config_data['device_settings_amd']['board_part']
            if pgm:
                edam['tool_options']['vivado']['pgm'] = 'vivado'
            else:
                edam['tool_options']['vivado']['pgm'] = 'none'
        else:
            print("Synthesis tool not yet supported")
            exit(0)
    else:
        print("Mode not recognized")
        exit(1)

    all_files = []

    for file in pre_built_files_vhdl:
            all_files.append({'name': os.path.relpath(file,bDir), 'file_type': config_data['pre_built_compontents']['source_type'], 'logical_name': 'basic_rtl'})
    for file in pre_built_testbenches_vhdl:
            all_files.append({'name': os.path.relpath(file,bDir), 'file_type': config_data['pre_built_compontents']['source_type'], 'logical_name': 'work'})
    for file in src_files + src_testbench_files:
            all_files.append({'name': os.path.relpath(file,bDir), 'file_type': config_data['project']['source_type'], 'logical_name': 'work'})
            
    #TODO: Make dynamic
    all_files.append({'name': os.path.relpath('./config/lab1.xdc',bDir), 'file_type': 'xdc'})
    edam['files'] = all_files

    backend = edatool.get_edatool(tool)(edam=edam, work_root=bDir)

    if not os.path.exists(bDir): 
        os.makedirs(bDir)
    # TODO: Catch exceptions

    backend.configure()
    # TODO: Potentially make this a pre-build hook
    if mode == "build-intel":
        project_tcl = open(bDir  + "\\" + project_options['name'] + ".tcl", "a")
        quartus_assign_tcl = open("./config/quartus_assign.tcl","r")
        for line in quartus_assign_tcl:
            project_tcl.write(line)
        project_tcl.close()
        quartus_assign_tcl.close()

    if not config_only:
        backend.build()
        backend.run()
    else: 
        exit(0)

    # Generate Ouptut Files
    #TODO: Use variable for output dir
    #TODO: Implement for other modes
    if mode == "sim":
        if project_options['sim_tool'] == 'xsim':
            if not os.path.exists("output"): 
                os.makedirs("output")
            copy(os.path.join(bDir, toplevel + ".wdb"), "output/")
            copy(os.path.join(bDir, toplevel + ".wcfg"), "output/")
            ouput_path = os.path.abspath("./output/")
            wdb_path = os.path.join(ouput_path, toplevel + ".wdb")
            wcfg_path = os.path.join(ouput_path, toplevel + ".wcfg")
            output_db = "{" + wdb_path + "}"
            output_wcfg = "{" + wcfg_path + "}"
            load_tcl = open("./output/load.tcl","w")
            load_tcl.writelines([
                    "catch {close_sim}\n",
                    "open_wave_database {db}\n".format(db=output_db),
                    "open_wave_config {cfg}\n".format(cfg=output_wcfg),
            ])
            load_tcl.close()
    # TODO: Add swtich to open output in gui for veiwing
    #Open Command: xsim -gui .\output\${toplevel}.wdb -view .\output\${toplevel}.

if __name__ == "__main__":
    main()