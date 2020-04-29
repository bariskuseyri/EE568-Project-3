newdocument(0)			-- 0: magnetic problem
						-- 1: electrostatic problem
						-- 2: heat flow problem
						-- 3: current flow problem

-- ERROR: mi_addarc arc segment degree is given in radians | should be in degrees
-- Display

mi_probdef(0, 'meters', 'planar', 1e-008, 0.100, 30, 0)	

stator = 1
rotor = 1
shaft = 1
double_layer = 0


-- Machine Parameters


Ns = 12			-- Number of slots
pp = 2			-- Number of pole-pairs
p = pp*2		-- Number of poles

I_rms = 5*10^-6 -- current density [A/mm2]
I_peak = 50		-- Peak excitation current

pi = 3.1415926535897932384626433		-- defining pi constant


stator_radius_outer = 0.1159
slot_radius_outer = 0.0959
stator_radius_inner = 0.0510
rotor_radius_outer = 0.050
airgap = stator_radius_inner - rotor_radius_outer
region_radius = (2*stator_radius_outer-stator_radius_inner)
radial_magnet_length = 0.004
shaft_radius = 0.010
magnet_arc = 0.8
slot_arc = 0.5


wire_diameter = 0.000644
fill_factor = 0.60


wire_area = (pi*(wire_diameter^2))
slot_area = ((pi*(slot_radius_outer^2))-(pi*(stator_radius_inner^2)))/(2*Ns)
N_cond = (slot_area*fill_factor)/wire_area


-- Materials

mi_getmaterial('Air')
mi_getmaterial('24 AWG')
mi_getmaterial('N45')
mi_getmaterial('M-15 Steel')
mi_getmaterial('Hiperco-50')



-- Circuit Definitions
coil = '24 AWG'
mi_addcircprop('A', I, 1)
mi_addcircprop('B', I, 1)
mi_addcircprop('C', I, 1)

-- region boundary
mi_addnode(region_radius,0)
mi_addnode((-1)*region_radius,0)
mi_addarc(region_radius,0,(-1)*region_radius,0,180,1)
mi_addarc((-1)*region_radius,0,region_radius,0,180,1)

mi_addblocklabel(0,region_radius-0.001)
mi_selectlabel(0,region_radius-0.001)
mi_setblockprop('Air', 1, 0, 0, 0, 0, 0)
mi_selectlabel(0,region_radius-0.001)

--airgap 

mi_addblocklabel(0,stator_radius_inner-1e-4)
mi_selectlabel(0,stator_radius_inner-1e-4)
mi_setblockprop('Air', 1, 0, 0, 0, 0, 0)
mi_selectlabel(0,stator_radius_inner-1e-4)

mi_addblocklabel(0,stator_radius_inner-airgap/2-1e-4)
mi_selectlabel(0,stator_radius_inner-airgap/2-1e-4)
mi_setblockprop('Air', 1, 0, 0, 0, 0, 0)
mi_selectlabel(0,stator_radius_inner-airgap/2-1e-4)

if stator == 1 then

	-- stator outer boundary
	mi_addnode(stator_radius_outer,0)
	mi_addnode((-1)*stator_radius_outer,0)
	mi_addarc(stator_radius_outer,0,(-1)*stator_radius_outer,0,180,1)
	mi_addarc((-1)*stator_radius_outer,0,stator_radius_outer,0,180,1)


	mi_addblocklabel(0,stator_radius_outer-0.001)
	mi_selectlabel(0,stator_radius_outer-0.001)
	mi_setblockprop('Hiperco-50', 1, 0, 0, 0, 0, 0)
	mi_selectlabel(0,stator_radius_outer-0.001)



	for n = 0, (2*Ns) do

		mi_addnode(slot_radius_outer*cos(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),slot_radius_outer*sin(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)))
		mi_addnode(slot_radius_outer*cos(n*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),slot_radius_outer*sin(n*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)))

		mi_addnode(stator_radius_inner*cos(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)))
		mi_addnode(stator_radius_inner*cos(n*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin(n*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)))

	end


	if double_layer == 1 then

		for n = 0, (2*Ns) do

			mi_addnode(slot_radius_outer*cos(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))),slot_radius_outer*sin(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))))
			mi_addnode(stator_radius_inner*cos(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))),stator_radius_inner*sin(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))))
			
		end

		for n = 0, (2*Ns) do

			mi_addarc(stator_radius_inner*cos(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*cos(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))),stator_radius_inner*sin(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))),(360)/(2*Ns),1)
			mi_addarc(stator_radius_inner*cos(n*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin(n*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*cos(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),2*(1-slot_arc)*(360)/(2*Ns),1)


			mi_addarc(stator_radius_inner*cos(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))),stator_radius_inner*sin(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))),stator_radius_inner*cos((n+1)*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin((n+1)*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),(360)/(2*Ns),1)

			mi_addarc(slot_radius_outer*cos(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),slot_radius_outer*sin(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),slot_radius_outer*cos(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))),slot_radius_outer*sin(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))),(360)/(2*Ns),1)
			mi_addarc(slot_radius_outer*cos(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))),slot_radius_outer*sin(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))),slot_radius_outer*cos((n+1)*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),slot_radius_outer*sin((n+1)*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),(360)/(2*Ns),1)

		end


		for n = 0, (2*Ns) do

			mi_addsegment(slot_radius_outer*cos(n*(2*pi)/(Ns)+((2*pi)/(2*2*Ns))),slot_radius_outer*sin(n*(2*pi)/(Ns)+((2*pi)/(2*2*Ns))),stator_radius_inner*cos(n*(2*pi)/(Ns)+((2*pi)/(2*2*Ns))),stator_radius_inner*sin(n*(2*pi)/(Ns)+((2*pi)/(2*2*Ns))))
			mi_addsegment(slot_radius_outer*cos(n*(2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),slot_radius_outer*sin(n*(2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*cos(n*(2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin(n*(2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns)))
			mi_addsegment(slot_radius_outer*cos(n*(2*pi)/(2*Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),slot_radius_outer*sin(n*(2*pi)/(2*Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*cos(n*(2*pi)/(2*Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin(n*(2*pi)/(2*Ns)-(1-slot_arc)*(2*pi)/(2*Ns)))
			mi_addsegment(stator_radius_inner*cos(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))),stator_radius_inner*sin(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))),slot_radius_outer*cos(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))),slot_radius_outer*sin(n*(2*pi)/(Ns)+((2*pi)/(2*Ns))))
		end

		for n = 0, Ns do

			mi_addblocklabel(((slot_radius_outer+stator_radius_inner)/2)*cos((n*(2*pi)/Ns)+(((2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns))/2)),((slot_radius_outer+stator_radius_inner)/2)*sin((n*(2*pi)/Ns)+(((2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns))/2)))
			mi_selectlabel(((slot_radius_outer+stator_radius_inner)/2)*cos((n*(2*pi)/Ns)+(((2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns))/2)),((slot_radius_outer+stator_radius_inner)/2)*sin((n*(2*pi)/Ns)+(((2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns))/2)))
			mi_setblockprop(coil, 1, 0, 0, 0, 0, 0)
			mi_selectlabel(((slot_radius_outer+stator_radius_inner)/2)*cos((n*(2*pi)/Ns)+(((2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns))/2)),((slot_radius_outer+stator_radius_inner)/2)*sin((n*(2*pi)/Ns)+(((2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns))/2)))

			mi_addblocklabel(((slot_radius_outer+stator_radius_inner)/2)*cos((n*(2*pi)/Ns)+(((2*pi)/(2*Ns)+((2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)))/2)),((slot_radius_outer+stator_radius_inner)/2)*sin((n*(2*pi)/Ns)+(((2*pi)/(2*Ns)+((2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)))/2)))
			mi_selectlabel(((slot_radius_outer+stator_radius_inner)/2)*cos((n*(2*pi)/Ns)+(((2*pi)/(2*Ns)+((2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)))/2)),((slot_radius_outer+stator_radius_inner)/2)*sin((n*(2*pi)/Ns)+(((2*pi)/(2*Ns)+((2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)))/2)))
			mi_setblockprop(coil, 1, 0, 0, 0, 0, 0)
			mi_selectlabel(((slot_radius_outer+stator_radius_inner)/2)*cos((n*(2*pi)/Ns)+(((2*pi)/(2*Ns)+((2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)))/2)),((slot_radius_outer+stator_radius_inner)/2)*sin((n*(2*pi)/Ns)+(((2*pi)/(2*Ns)+((2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)))/2)))

		end




	elseif double_layer == 0 then

		for n = 0, (2*Ns) do

			mi_addsegment(slot_radius_outer*cos(n*(2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),slot_radius_outer*sin(n*(2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*cos(n*(2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin(n*(2*pi)/(2*Ns)+(1-slot_arc)*(2*pi)/(2*Ns)))
			mi_addsegment(slot_radius_outer*cos(n*(2*pi)/(2*Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),slot_radius_outer*sin(n*(2*pi)/(2*Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*cos(n*(2*pi)/(2*Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin(n*(2*pi)/(2*Ns)-(1-slot_arc)*(2*pi)/(2*Ns)))
			
		end

		for n = 0, (2*Ns) do

			mi_addarc(slot_radius_outer*cos(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),slot_radius_outer*sin(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),slot_radius_outer*cos((n+1)*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),slot_radius_outer*sin((n+1)*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),(360)/(2*Ns),1)
			mi_addarc(stator_radius_inner*cos(n*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin(n*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*cos(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),2*(1-slot_arc)*(360)/(2*Ns),1)
			mi_addarc(stator_radius_inner*cos(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin(n*(2*pi)/(Ns)+(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*cos((n+1)*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),stator_radius_inner*sin((n+1)*(2*pi)/(Ns)-(1-slot_arc)*(2*pi)/(2*Ns)),2*(1-slot_arc)*(360)/(2*Ns),1)
		
		end

		for n = 0, Ns do

			mi_addblocklabel(((slot_radius_outer+stator_radius_inner)/2)*cos((n*(2*pi)/Ns)+((2*pi)/(2*Ns))),((slot_radius_outer+stator_radius_inner)/2)*sin((n*(2*pi)/Ns)+((2*pi)/(2*Ns))))
			mi_selectlabel(((slot_radius_outer+stator_radius_inner)/2)*cos((n*(2*pi)/Ns)+((2*pi)/(2*Ns))),((slot_radius_outer+stator_radius_inner)/2)*sin((n*(2*pi)/Ns)+((2*pi)/(2*Ns))))
			mi_setblockprop(coil, 1, 0, 0, 0, 0, 0)
			mi_selectlabel(((slot_radius_outer+stator_radius_inner)/2)*cos((n*(2*pi)/Ns)+((2*pi)/(2*Ns))),((slot_radius_outer+stator_radius_inner)/2)*sin((n*(2*pi)/Ns)+((2*pi)/(2*Ns))))

		end
	end
else
end


-- airgap analyzation boundary
mi_addnode(stator_radius_inner-(airgap/2),0)
mi_addnode((-1)*(stator_radius_inner-(airgap/2)),0)
mi_addarc(stator_radius_inner-(airgap/2),0,(-1)*(stator_radius_inner-(airgap/2)),0,180,1)
mi_addarc((-1)*(stator_radius_inner-(airgap/2)),0,stator_radius_inner-(airgap/2),0,180,1)



-- rotor

if rotor == 1 then

	for n = 0, (2*p) do

		mi_addnode(rotor_radius_outer*cos(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*sin(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)))
		mi_addnode(rotor_radius_outer*cos(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*sin(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)))

		mi_addnode((rotor_radius_outer-radial_magnet_length)*cos(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)))
		mi_addnode((rotor_radius_outer-radial_magnet_length)*cos(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)))
		
	end

	for n = 0, (2*p) do

		mi_addarc((rotor_radius_outer-radial_magnet_length)*cos(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*cos((n+1)*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin((n+1)*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),((360)/(p))-(1-magnet_arc)*(360)/(p),1)
		mi_addarc((rotor_radius_outer-radial_magnet_length)*cos((n+1)*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin((n+1)*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*cos((n+1)*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin((n+1)*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(1-magnet_arc)*(360)/(p),1)
		mi_addarc(rotor_radius_outer*cos(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*sin(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*cos((n+1)*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*sin((n+1)*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),magnet_arc*(360/p),1)


	end

	for n = 0 , (2*p) do

		mi_addsegment(rotor_radius_outer*cos(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*sin(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*cos(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin(n*(2*pi)/(p)+(1-magnet_arc)*(2*pi)/(2*p)))
		mi_addsegment(rotor_radius_outer*cos(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),rotor_radius_outer*sin(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*cos(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)),(rotor_radius_outer-radial_magnet_length)*sin(n*(2*pi)/(p)-(1-magnet_arc)*(2*pi)/(2*p)))

	end

	mi_addblocklabel(0,(rotor_radius_outer+shaft_radius)/2)
	mi_selectlabel(0,(rotor_radius_outer+shaft_radius)/2)
	mi_setblockprop('M-15 Steel', 1, 0, 0, 0, 0, 0)
	mi_selectlabel(0,(rotor_radius_outer+shaft_radius)/2)


else


end


-- shaft

if shaft == 1 then

	mi_addnode(shaft_radius,0)
	mi_addnode((-1)*shaft_radius,0)
	mi_addarc(shaft_radius,0,(-1)*shaft_radius,0,180,1)
	mi_addarc((-1)*shaft_radius,0,shaft_radius,0,180,1)

	mi_addblocklabel(0,shaft_radius-0.001)
	mi_selectlabel(0,shaft_radius-0.001)
	mi_setblockprop('Air', 1, 0, 0, 0, 0, 0)
	mi_selectlabel(0,shaft_radius-0.001)

else
end





for n = 0, (2*pi-1) do

	mi_addblocklabel((rotor_radius_outer-(radial_magnet_length/2))*cos(n*(2*pi)/(p)+(pi/p)),(rotor_radius_outer-(radial_magnet_length/2))*sin(n*(2*pi)/(p)+(pi/p)))

	mi_selectlabel((rotor_radius_outer-(radial_magnet_length/2))*cos(((2*n+1)/2)*(2*pi)/(p)),(rotor_radius_outer-(radial_magnet_length/2))*sin(((2*n+1)/2)*(2*pi)/(p)))
	mi_setblockprop('N45', 1, 0, 0, 45+90*n + n*180, 0, 0)
	mi_selectlabel((rotor_radius_outer-(radial_magnet_length/2))*cos(((2*n+1)/2)*(2*pi)/(p)),(rotor_radius_outer-(radial_magnet_length/2))*sin(((2*n+1)/2)*(2*pi)/(p)))
	
end




mi_selectcircle(0, 0, stator_radius_inner-1e-12, 4)
mi_setgroup(1)


mi_saveas("Draft2.fem")