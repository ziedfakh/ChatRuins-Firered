function updateState()
	if(state=="overworld") and(memory.readdword(0x02002D50)~=0) then pause='pause'

	elseif (memory.readbyte(0x02022B4C)==12) and(state~="battle") and(memory.readbyte(0x03000F9C)==1)then
		--emu.message("battle")

		state="battle"
		print(state)
		if((memory.readbyte(0x0203707B)==1)and(memory.readbyte(0x0203707A)==2))then
			memory.writebyte(0x02022B4C,4)
			state="overworld"
			print(state)
		end
	elseif(state=="overworld")and(memory.readbyte(0x02022B4C)==28)and(memory.readbyte(0x03000F9C)==1) then
		state="battle"
		print(state)
	end

	if((memory.readbyte(0x02022B4C)==0)and(state~="wild"))then
		state="wild"
		print(state)	
		local file = io.open("encounter.txt", "r")
		wilds = file:read "*a"
		file:close()

		io.open("encounter.txt","w"):close()

		wildlist={}
		if(#wilds>1) then
			for token in string.gmatch(wilds, "[^\n]+") do
				if (token~="") and (token~="\n") then
					table.insert(wildlist,token)
				end

			end
		chooseEncounter(wildlist[ math.random( #wildlist ) ])
		healEnemy()
		end
	elseif((memory.readbyte(0x0203707B)==1)and(memory.readbyte(0x0203707A)==2)and(state=="wild"))then
		memory.writebyte(0x02022B4C,4)
		state="overworld"
		print(state)
	elseif(state=="wild")and(memory.readbyte(0x02022B4C)==0)then pause='pause'
	elseif(state~="overworld") and (memory.readdword(0x02002D50)~=0)then
		state="overworld"
		print(state)
	
	end
end

function draw(arr,X,Y)
	for j=1,#arr do
	for i=1,#(arr[1]) do
		
			
			gui.pixel(X+i, Y+j, arr[j][i])

		end
	end
end

function updateGUI()
	local x,y,z = gui.getpixel(135, 108)
	letterx=185
	lettery=96
	barx=173
	bary=91
	local lvlupx,lvlupy,lvlupz = gui.getpixel(148, 89)
	--print(gui.getpixel(148, 89))
	
	if(x==80 and y==104 and z==96) then
		if(state~="overworld")and (not (lvlupx==112 and lvlupy== 104 and lvlupz== 128)) then

			if(memory.readdword(0x02023C30)==0x0000) then draw(empt,141,95+memory.readbyte(0x029616DA))
				elseif(memory.readdword(0x02023C30)==0x0040) then draw(par,141,95+memory.readbyte(0x029616DA))
				elseif(memory.readdword(0x02023C30)==0x0110) then draw(brn,141,95+memory.readbyte(0x029616DA))
				elseif((memory.readdword(0x02023C30)==0x0003)or(memory.readdword(0x02023C30)==0x0002)or(memory.readdword(0x02023C30)==0x0001) )then draw(slp,141,95+memory.readbyte(0x029616DA))
				else draw(psn,141,95+memory.readbyte(0x029616DA))
			end



			local x1,y2,z3 = gui.getpixel(210,88)
			--print(  gui.getpixel(210, 88) )
			--gui.pixel(210, 88,"black")

			if (x1==248 and y2==248 and z3==216) then
				
				local HP=memory.readword(0x02023c0c)
				local maxhp=memory.readword(0x020242DC+0x64*memory.readbyte(0x02023BCE))
				local ratio = 48*(HP)/maxhp
				local ratioperc = 100*(HP)/maxhp

				draw(numbers[HP%10],letterx+10,lettery+memory.readbyte(0x029616DA))
				HP = math.floor(HP/10)
				draw(numbers[HP%10],letterx+5,lettery+memory.readbyte(0x029616DA))
				HP = math.floor(HP/10)
				if(HP%10==0) then
				draw(nnone,letterx,lettery+memory.readbyte(0x029616DA))
				else
				draw(numbers[HP%10],letterx,lettery+memory.readbyte(0x029616DA))
				end

				if(ratioperc>50) then
					color={"#58d080","#70f8a8"}
				elseif(ratioperc>21) then
					color={"#c8a808","#f8e038"}
				else
					color={"#a84048","#f85838"}	
				end

				if(memory.readword(0x02023c0c)==1)then
					ratio=1
				end

				for i=1,48 do
					if(i>math.floor(ratio)) then
						gui.pixel(barx+i, bary+memory.readbyte(0x029616DA),"#484058")
					else
						gui.pixel(barx+i, bary+memory.readbyte(0x029616DA),color[1])
					end
				end

				for j=1,2 do
					for i=1,48 do
						if(i>math.floor(ratio)) then
							gui.pixel(barx+i, bary+j+memory.readbyte(0x029616DA),"#506858")
						else
							gui.pixel(barx+i, bary+j+memory.readbyte(0x029616DA),color[2])
						end
					end
				end


			end


		end
	end
end

state="overworld"

while(true) do
	vba.frameadvance()

	updateGUI()
end



