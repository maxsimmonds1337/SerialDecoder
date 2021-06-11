
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name SerialDecoder -dir "D:/Repos/FPGA/SerialDecoder/planAhead_run_1" -part xc3sd1800afg676-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/Repos/FPGA/SerialDecoder/top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/Repos/FPGA/SerialDecoder} }
set_property target_constrs_file "top.ucf" [current_fileset -constrset]
add_files [list {top.ucf}] -fileset [get_property constrset [current_run]]
link_design
