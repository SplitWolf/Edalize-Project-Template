set_global_assignment -name NUM_PARALLEL_PROCESSORS 16
#============================================================
# CLOCK
#============================================================
# CLOCK_50
set_location_assignment PIN_Y2 -to GClock
# set_location_assignment PIN_AG14 -to CLOCK2_50
# set_location_assignment PIN_AG15 -to CLOCK3_50
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK_50
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK2_50
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK3_50

# LEDR[0]
set_location_assignment PIN_G19 -to MSTL[0]
# LEDR[1]
set_location_assignment PIN_F19 -to MSTL[1]
# LEDR[2]
set_location_assignment PIN_E19 -to MSTL[2]
# LEDR[3]
# set_location_assignment PIN_F21 -to LEDR[3]
# LEDR[4]
set_location_assignment PIN_F18 -to SSTL[0]
# LEDR[5]
set_location_assignment PIN_E18 -to SSTL[1]
# LEDR[6]
set_location_assignment PIN_J19 -to SSTL[2]


# set_location_assignment PIN_H19 -to LEDR[7]
# set_location_assignment PIN_J17 -to LEDR[8]
# set_location_assignment PIN_G17 -to LEDR[9]
# set_location_assignment PIN_J15 -to LEDR[10]
# set_location_assignment PIN_H16 -to LEDR[11]
# set_location_assignment PIN_J16 -to LEDR[12]
# set_location_assignment PIN_H17 -to LEDR[13]
# set_location_assignment PIN_F15 -to LEDR[14]
# set_location_assignment PIN_G15 -to LEDR[15]
# set_location_assignment PIN_G16 -to LEDR[16]
# set_location_assignment PIN_H15 -to LEDR[17]

#============================================================
# KEY
#============================================================
# KEY[0]
# set_location_assignment PIN_M23 -to SSCS
# KEY[1]
set_location_assignment PIN_M21 -to SSCS
# KEY[2]
# set_location_assignment PIN_N21 -to KEY[2]
# KEY[3]
# set_location_assignment PIN_R24 -to KEY[3]

#============================================================
# SW
#============================================================
# SW[0]
set_location_assignment PIN_AB28 -to MSC[0]
# SW[1]
set_location_assignment PIN_AC28 -to MSC[1]
# SW[2]
set_location_assignment PIN_AC27 -to MSC[2]
# SW[3]
set_location_assignment PIN_AD27 -to MSC[3]
# SW[4]
set_location_assignment PIN_AB27 -to SSC[0]
# SW[5]
set_location_assignment PIN_AC26 -to SSC[1]
# SW[6]
set_location_assignment PIN_AD26 -to SSC[2]
# SW[7]
set_location_assignment PIN_AB26 -to SSC[3]
# set_location_assignment PIN_AC25 -to SW[8]
# set_location_assignment PIN_AB25 -to SW[9]
# set_location_assignment PIN_AC24 -to SW[10]
# set_location_assignment PIN_AB24 -to SW[11]
# set_location_assignment PIN_AB23 -to SW[12]
# set_location_assignment PIN_AA24 -to SW[13]
# set_location_assignment PIN_AA23 -to SW[14]
# set_location_assignment PIN_AA22 -to SW[15]
# set_location_assignment PIN_Y24 -to SW[16]
# SW[17]
set_location_assignment PIN_Y23 -to GReset

#============================================================
# SEG7
#============================================================
# HEX0
set_location_assignment PIN_G18 -to BCD1[0]
set_location_assignment PIN_F22 -to BCD1[1]
set_location_assignment PIN_E17 -to BCD1[2]
set_location_assignment PIN_L26 -to BCD1[3]
set_location_assignment PIN_L25 -to BCD1[4]
set_location_assignment PIN_J22 -to BCD1[5]
set_location_assignment PIN_H22 -to BCD1[6]
# HEX1
set_location_assignment PIN_M24 -to BCD2[0]
set_location_assignment PIN_Y22 -to BCD2[1]
set_location_assignment PIN_W21 -to BCD2[2]
set_location_assignment PIN_W22 -to BCD2[3]
set_location_assignment PIN_W25 -to BCD2[4]
set_location_assignment PIN_U23 -to BCD2[5]
set_location_assignment PIN_U24 -to BCD2[6]