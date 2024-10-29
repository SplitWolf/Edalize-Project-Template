import os
from argparse import ArgumentParser
from pathlib import Path
from edalize import *
from edalize import edatool

import yaml
import glob
#   pnr: '' # quartus/dse/none

def main():
    parser = ArgumentParser()
    parser.add_argument("-m","--mode",dest="mode",help="Mode to compile sim (complies _tb file), build-intel, or build-amd",default="sim")
    args = parser.parse_args()
    mode = args.mode
    print(mode)


    with open('./config/config.yml', 'r') as config_file:
        config_data = yaml.safe_load(config_file)

    project_options = config_data['project']
    build_dir = project_options['build_dir']

    pre_built_files_vhdl = glob.glob(os.path.join(config_data['pre_built_compontents']['location'], "*.vhd"))
    pre_built_testbenches_vhdl = glob.glob(os.path.join(config_data['pre_built_compontents']['location'], "testbenches/*.vhd"))

    src_files = glob.glob(os.path.join('./src', "*.vhd"))
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
            xsim_config_tcl = "../../config/xsim_cfg_" + toplevel + ".tcl"
            if not Path(xsim_config_tcl).is_file():
                print("Using default xsim log script")
                xsim_config_tcl = "../../config/xsim_cfg.tcl"
            edam['tool_options']['xsim']['xsim_options'] = ["--wdb " + "./" + toplevel + '.wdb', "--tclbatch " + xsim_config_tcl]
            # TODO: Copy output file after running tool
        else: 
            print("Sim tool not yet supported")
            exit(0)
    elif mode == "build-intel":
        # TODO: Pass quartus options for pin assignments
        if project_options['synth_tool'] == 'quartus':
            tool = 'quartus'
            bDir = build_dir + "\\synth"
            edam['tool_options']['quartus'] = {}
            edam['tool_options']['quartus']['family'] = config_data['device_settings']['family']
            edam['tool_options']['quartus']['device'] = config_data['device_settings']['device']
            edam['tool_options']['quartus']['cable'] = config_data['device_settings']['cable']
            edam['tool_options']['quartus']['pgm'] = config_data['device_settings']['pgm']
            edam['tool_options']['quartus']['board_device_index']= config_data['device_settings']['board_device_index']
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
            
    edam['files'] = all_files

    backend = edatool.get_edatool(tool)(edam=edam, work_root=bDir)

    if not os.path.exists(bDir): 
        os.makedirs(bDir)

    # TODO: Catch exceptions

    backend.configure()
    # try:
    backend.build()
    # except:
    #     subprocess.run(["quartus_map", "./build/test_project"]) 
    backend.run()
    # backend.run()

if __name__ == "__main__":
    main()