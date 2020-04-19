newdocument(0)			-- 0: magnetic problem
						-- 1: electrostatic problem
						-- 2: heat flow problem
						-- 3: current flow problem

filename = "Draft1.fem"

mi_probdef(0, 'meters', 'planar', 1e-008, 0.100, 30, 0)	
-- Machine Parameters


Ns = 12			-- Number of slots
pp = 2			-- Number of pole-pairs
p = pp*2		-- Number of poles

pi = 3.1415926535897932384626433		-- defining pi constant


region_radius = 0.100
rotor_radius_outer = 0.050
radial_magnet_length = 0.004
airgap = 0.001
stator_radius_inner = rotor_radius_outer + airgap

-- stator_radius_outer

back_iron = (stator_radius_inner * 2 * pi)/(Ns*2)
stator_radius_outer = stator_radius_inner + 2*back_iron


shaft_radius = 0.010
magnet_arc = 0.8
slot_arc = 0.5


wire_diameter = 0.000644
fill_factor = 0.60



-- Materials

mi_getmaterial('Air')
mi_getmaterial('Hiperco-50')
mi_getmaterial('N45')
mi_getmaterial('M-15 Steel')



-- region boundary
mi_addnode(region_radius,0)
mi_addnode((-1)*region_radius,0)
mi_addarc(region_radius,0,(-1)*region_radius,0,180,1)
mi_addarc((-1)*region_radius,0,region_radius,0,180,1)


-- stator outer boundary
mi_addnode(stator_radius_outer,0)
mi_addnode((-1)*stator_radius_outer,0)
mi_addarc(stator_radius_outer,0,(-1)*stator_radius_outer,0,180,1)
mi_addarc((-1)*stator_radius_outer,0,stator_radius_outer,0,180,1)

-- stator inner boundary
mi_addnode(stator_radius_inner,0)
mi_addnode((-1)*stator_radius_inner,0)
mi_addarc(stator_radius_inner,0,(-1)*stator_radius_inner,0,180,1)
mi_addarc((-1)*stator_radius_inner,0,stator_radius_inner,0,180,1)

-- airgap analyzation boundary
mi_addnode(stator_radius_inner-(airgap/2),0)
mi_addnode((-1)*(stator_radius_inner-(airgap/2)),0)
mi_addarc(stator_radius_inner-(airgap/2),0,(-1)*(stator_radius_inner-(airgap/2)),0,180,1)
mi_addarc((-1)*(stator_radius_inner-(airgap/2)),0,stator_radius_inner-(airgap/2),0,180,1)




mi_addblocklabel(0,region_radius-0.001)
mi_selectlabel(0,region_radius-0.001)
mi_setblockprop('Air', 1, 0, 0, 0, 0, N_cond)
mi_selectlabel(0,region_radius-0.001)

mi_addblocklabel(0,stator_radius_outer-0.001)
mi_selectlabel(0,stator_radius_outer-0.001)
mi_setblockprop('Hiperco-50', 1, 0, 0, 0, 0, 0)
mi_selectlabel(0,stator_radius_outer-0.001)

mi_addblocklabel(0,stator_radius_inner-(airgap/4))
mi_selectlabel(0,stator_radius_inner-(airgap/4))
mi_setblockprop('Air', 1, 0, 0, 0, 0, 0)
mi_selectlabel(0,stator_radius_inner-(airgap/4))

mi_addblocklabel(0,stator_radius_inner-0.001)
mi_selectlabel(0,stator_radius_inner-0.001)
mi_setblockprop('Air', 1, 0, 0, 0, 0, 0)
mi_selectlabel(0,stator_radius_inner-0.001)

mi_addblocklabel(0,rotor_radius_outer-radial_magnet_length-0.001)
mi_selectlabel(0,rotor_radius_outer-radial_magnet_length-0.001)
mi_setblockprop('M-15 Steel', 1, 0, 0, 0, 0, 0)
mi_selectlabel(0,rotor_radius_outer-radial_magnet_length-0.001)



for n = 0, (2*p-1) do

	mi_addnode(rotor_radius_outer*cos(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*sin(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)))
	mi_addnode(rotor_radius_outer*cos(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*sin(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)))

	mi_addnode((rotor_radius_outer-radial_magnet_length)*cos(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)))
	mi_addnode((rotor_radius_outer-radial_magnet_length)*cos(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)))
	
end

for n = 0, (2*p-1) do

	mi_addarc((rotor_radius_outer-radial_magnet_length)*cos(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*cos((n+1)*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin((n+1)*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),((360)/(p))-(1-magnet_arc)*(360)/(p),1)
	mi_addarc((rotor_radius_outer-radial_magnet_length)*cos(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*cos(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(1-magnet_arc)*(360)/(2*pp),1)
	
	mi_addarc(rotor_radius_outer*cos(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*sin(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*cos((n+1)*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*sin((n+1)*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),((360)/(2*pp))-(1-magnet_arc)*(360)/(2*pp),1)

	mi_addsegment(rotor_radius_outer*cos(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*sin(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*cos(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(p)))
	mi_addsegment(rotor_radius_outer*cos(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*sin(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*cos(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(p)))

end

for n = 0, (2*pi-1) do

	mi_addblocklabel((rotor_radius_outer-(radial_magnet_length/2))*cos(n*(2*pi)/(p)+(pi/p)),(rotor_radius_outer-(radial_magnet_length/2))*sin(n*(2*pi)/(p)+(pi/p)))

	mi_selectlabel((rotor_radius_outer-(radial_magnet_length/2))*cos(((2*n+1)/2)*(2*pi)/(p)),(rotor_radius_outer-(radial_magnet_length/2))*sin(((2*n+1)/2)*(2*pi)/(p)))
	mi_setblockprop('N45', 1, 0, 0, 45+90*n + n*180, 0, 0)
	mi_selectlabel((rotor_radius_outer-(radial_magnet_length/2))*cos(((2*n+1)/2)*(2*pi)/(p)),(rotor_radius_outer-(radial_magnet_length/2))*sin(((2*n+1)/2)*(2*pi)/(p)))
	
end



mi_saveas("Draft1.fem")




mi_close()



open(filename)			-- open orignal femm source
mi_saveas("temp/temp.fem")	-- save temporary

mi_analyse()
mi_loadsolution()

mo_seteditmode("contour")

mo_selectpoint(stator_radius_inner-(airgap/2),0)
mo_selectpoint((-1)*(stator_radius_inner-(airgap/2)),0)



mo_makeplot(1, 1500, "airgap_flux_density.emf", 0)
mo_savebitmap("airgap_flux_density.bmp")

--mo_close()

--remove("temp/temp.fem") -- delete temporary files
--remove("temp/temp.ans")

messagebox("!!! Your images are ready in folder out/images !!!")
