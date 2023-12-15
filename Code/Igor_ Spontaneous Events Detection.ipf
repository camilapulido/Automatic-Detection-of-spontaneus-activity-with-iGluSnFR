#pragma rtGlobals=3		// Use modern global access method and strict wave access.
#include <Waves Average>

Function iGlusBoutonsILoadMinis(VDate, CellNo,CtrlNo)
	
	String VDate
	Variable CellNo, CtrlNo
	Variable/G CtrlN = CtrlNo
	String/G NameBase = VDate+"_C"+num2str(CellNo)
	string iGlusType = "iGlus_v875"
	string/G Folder = "E:iGluSnFR:"+iGlusType+":perBouton:"
	 	
	Make/T/o/N = 4 NameList
	Make/T/o/N =(dimsize(NameList,0)) NameListout
	
	variable/G HighAPs = dimsize(NameList,0)
	variable/G Glut= 0  /// If no glut Glut == 1
  	
  string Type = "" // "M13KD_"
  	
	NameList[0]= Type+"Gluta100mM"   ////// Gluta 
	NameList[1]= Type+"AP"
	NameList[2]= Type+"AP_TTx"
	NameList[3]= Type+"MinisTTx"
			
	NameListout[0]= "Gluta100mM"
	NameListout[1]= "Ctrl1AP"
	NameListout[2]= "TTx1AP"
	NameListout[3]= "MinisTTx"
	
	variable x, y
	for(x=Glut; x<=(HighAPs-1);x+=1)
		if (x >=1)
			if (x==1 || x == 2) 
				variable Total = 1
			elseif (x == 3)
				Total = CtrlNo
				variable Space = 20
			endif
			
			for (y=0; y<= Total-1; y+=1)
				
				string name = NameBase + "_"+Namelist[x]+"_"+num2str(y)+"_Btns.xls"
				string name2  = NameListout[x]+"_"+num2str(y)+ "_AVG"
				String nameOut = NameListout[x]+"_"+num2str(y)+"_Btns"
				
				String NameBlack = NameBase + "_"+Namelist[x]+"_"+num2str(y)+"_Black.txt"
				String NameOutBlack = NameListout[x]+"_"+num2str(y)+"_Black"
				if (x==1 || x==2)
					name = NameBase+"_"+Namelist[x]+"_Btns.xls"
					name2  = NameListout[x]+"_AVG"
					nameOut = NameListout[x]+"_Btns"
					
					NameBlack = NameBase + "_"+Namelist[x]+"_Black.txt"
					NameOutBlack = NameListout[x]+"_Black"
				endif	
				/// Load responses per bouton 
				LoadWave/J/M/D/A=W/U={0,0,1,0}/W/K=0 Folder+NameBase+":"+name
				wave W0
				duplicate/o W0, $nameOut
				KillWaves W0
				
				
				if (x==3)
					redimension/N=(dimsize($nameOut,0)+Space,-1) $nameOut
					redimension/N=(-1,dimsize($nameOut,1)-1) $nameOut
					wave Wtest =  $nameOut
					Wtest[dimsize($nameOut,0)-Space,]=NaN
				endif
				
				/////// Load Background 
						
				LoadWave/J/D/W/N/O/K=0 Folder+NameBase+":"+NameBG
				wave MeanW
				if (x==3)
					redimension/N=(dimsize(MeanW,0)+Space,-1) MeanW
					MeanW[dimsize(MeanW,0)-Space,]=NaN
				endif
				duplicate/O MeanW, $NameOutBG
				killwaves MeanW
		
			endfor
			
					
			string Roislist = WaveList(NameListout[x]+"*_Btns",";","")
			Concatenate/Kill/O/NP=0  Roislist, WConca
			duplicate/o WConca, $NameListout[x]+"_Btns"
			KillWaves WConca 
					
			Roislist = WaveList(NameListout[x]+"*_Black*",";","")
			Concatenate/Kill/O/NP=0  Roislist, WConca
			
			duplicate/o WConca, $NameListout[x]+"_Btns_BG"
			KillWaves WConca 
	
			
		elseif (x == 0)
				name = NameBase + "_"+Namelist[x]+"_Btns.xls"
				name2 = NameListout[x]+"_Btns"
				LoadWave/J/M/D/A=W/U={0,0,1,0}/W/K=0  Folder+NameBase+":"+name
				wave W0
				duplicate/o W0, $name2
				KillWaves W0
				redimension/N=(-1,dimsize($name2,1)-1) $name2
				
				NameBlack = NameBase+"_"+Namelist[x]+"_BG.txt"
				NameOutBlack = NameListout[x]+"_BG"
				
				LoadWave/J/D/W/N/O/K=0 Folder+NameBase+":"+NameBG
				wave MeanW
				duplicate/O MeanW, $NameOutBG
				Killwaves MeanW
					
		endif
	endfor
		
end

////////////////////////////////////////////
////////////////////////////////////////////
Function Minis_iGlus(sucroseFile)
	variable sucroseFile
	Variable/G CtrlN
	wave MinisTTx_Btns, MinisTTx_Btns_BG
	
	variable MiniFileLength = ((dimsize(MinisTTx_Btns,0)-(20*CtrlN))/CtrlN
	variable/G SucFrame =(MiniFileLength*sucroseFile)+(sucroseFile*20) // space =20
	
	variable/G dX = 0.0103
	
	variable NoFrames = dimsize(MinisTTx_Btns, 0)
	variable NoBoutons = dimsize(MinisTTx_Btns, 1)
	variable Bouton, frame
	
	duplicate/O/R=[][0] MinisTTx_Btns, WTime
	WTime=(p*dX)
	
	duplicate/o MinisTTx_Btns, MinisTTx_Btn_F
	MinisTTx_Btn_F =NaN
		
	duplicate/o MinisTTx_Btns, MinisTTx_Btn_dF
	MinisTTx_Btn_dF =NaN
	
	for (Bouton =0; Bouton<= NoBoutons-1; Bouton +=1)	
		duplicate/O/R=[][Bouton] MinisTTx_Btns, WTraceF
		WTraceF-=MinisTTx_Btns_BG
		
		wavestats/Q/R=[SucFrame,SucFrame+50] WTraceF
		Variable BL=V_AVG
				
		duplicate/O WTraceF, WTracedF
		WTracedF -=BL
		
		wavestats/Q/R=[SucFrame,SucFrame+50] WTracedF
		variable/G dF_Sdev = V_sdev
		Variable dF_BL=V_AVG
		
			for(frame = 0;  frame<= (NoFrames-1); frame+=1)
				MinisTTx_Btn_F[frame][Bouton] = WTraceF[frame]
				MinisTTx_Btn_dF[frame][Bouton] = WTracedF[frame]
			endfor
		
		Differentiate/DIM=0  MinisTTx_Btn_dF/D=$nameofwave(MinisTTx_Btn_dF)+"_DIF"
	endfor
	Killwaves WTraceF, WTracedF
end

//////////

function ALL_Btns_Analysis() 
	wave MinisTTx_Btn_dF
	variable/G NoEvents
	variable/G NumofBtns = dimsize(MinisTTx_Btn_dF,1)
	Make/O/N=(NumofBtns) NoEvents_Btns
	
	variable x

	for(x=0;x<=(NumofBtns-1); x+=1)
		MinisperBtn(x)
		NoEvents_Btns[x] = NoEvents
	endfor
	
	wavestats/Q NoEvents_Btns
	
	Display /W=(685.5,79.25,1026,326) NoEvents_Btns
	ModifyGraph mode=8
	ModifyGraph marker=19
	ModifyGraph rgb=(39168,39168,39168)
	ModifyGraph hbFill=5
	ModifyGraph axThick=1.2
	ModifyGraph axisEnab(bottom)={0.05,1}
	Label left "No. Events"
	Label bottom "No. Bouton"
	SetAxis left 0, V_Max
	TextBox/C/N=text0/F=0/M/H={15,2,10}/A=MC/X=30.68/Y=45.35 "Total events =" + num2str(V_Sum)
	
end
	
//////

function MinisperBtn(btn)
	variable btn
	LocMinisperBtn_FirstLoop(btn) 
	LocMinisperBtn_SecondLoop(btn)
	 IndividualMinis(btn)
end

////////////////////////////////////////////
////////////////////////////////////////////

Function LocMinisperBtn_FirstLoop(btn) //find levels after a threshold
	variable btn
	
	variable/G SdevTimes =1.3
	
	variable/G SucFrame
	variable level	
	wave MinisTTx_Btn_dF_DIF, WTime
		
	duplicate/O/R=[][btn] MinisTTx_Btn_dF_DIF, Wtrace
		
	wavestats/Q/R=[SucFrame,SucFrame+150] Wtrace
	Level = V_AVG+(V_sdev*SdevTimes) /// thershold
		
	Make/O/D/N=0 WLevels
	
	findlevels/Q/B=3/M=3/EDGE=1/D=WLevels Wtrace, Level // Point for event

	
	duplicate/O WLevels, WValues
	WValues = nan
	
	variable x
	for (x=0; x<=dimsize(WLevels,0)-1;x+=1)
		WValues[x] = Wtrace[WLevels[x]]		
	endfor
	
	doWindow/K Checking
	string ChekingMacro = "Checking()"
	Execute ChekingMacro
	
	AppendToGraph/W= Checking $"MinisTTx_Btn_dF_DIF"[][btn] //Vs WTime
	AppendToGraph/W= Checking WValues vs WLevels
	ModifyGraph mode(WValues)=3,rgb(WValues)=(0,0,0)
	Killwaves WTrace
end

/////////////


Function LocMinisperBtn_SecondLoop(btn) // center levels to max point
	variable btn
	wave WLevels, WValues
	wave MinisTTx_Btn_dF
	duplicate/o/R=[][btn] MinisTTx_Btn_dF, Wtrace
	
	variable x
	for (x=0; x<=dimsize(WLevels,0)-1;x+=1)
		variable LevelPoint = round(WLevels[x])
		wavestats/Q/R=[LevelPoint-3, LevelPoint+4] Wtrace
		
		WLevels[x] = V_MaxRowLoc
		WValues[x] = V_Max
		 
	endfor
	
	doWindow/K Checking
	string ChekingMacro = "Checking()"
	Execute ChekingMacro
	
	AppendToGraph/W= Checking $"MinisTTx_Btn_dF"[][btn]
	AppendToGraph/W= Checking WValues vs WLevels
	ModifyGraph mode(WValues)=3,rgb(WValues)=(0,0,0)
	Killwaves WTrace
		
end

/////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
function IndividualMinis(btn)

	variable btn
	wave WLevels, WValues
	wave MinisTTx_Btn_dF
	
	duplicate/o/R=[][btn] MinisTTx_Btn_dF, Wtrace
	duplicate/O WLevels, MiniTime
	MiniTime =Nan
	duplicate/o WLevels, WdFMinis
	WdFMinis = Nan
	
	variable/G dX
	variable x, consecutives =0
	string WindowName = "ALLMinis_Btn"+num2str(btn)	
	doWindow/K DistandMinis 
	doWindow/K ConsecutiveMinis
	doWindow/K $WindowName 
	
	
	PPTDoKillMultipleWaves ("WOut", 1)
	
	//Display/k =1/N=DistandMinis
	//Display/k =1/N=ConsecutiveMinis
	Display/k =1/N= MinisTemporal
	
	
	for (x=0; x<=dimsize(WLevels,0)-1;x+=1)
		variable Level = WLevels[x]
		duplicate/O/R=[level-30,level+70] Wtrace, $"WOut"+num2str(x)  /// point 30 is located the mini peak
		wave WMini = $"WOut"+num2str(x)
		
		variable 	dim = dimsize(WMini, 0)
		if ( dim<101)
			Redimension/N=(101,-1) WMini
			WMini[dim,] = nan			
		endif
		SetScale/P x 0,dX,"", WMini	
		
		if (x== 0)
			wavestats/Q/R=[0,20]  WMini
			WMini-=V_AVG			
			//appendtograph/W=DistandMinis  WMini 	
		else
			if ((WLevels[x]-WLevels[x-1])>=40)
				wavestats/Q/R=[15, 24] WMini
				WMini-=V_AVG		
				//appendtograph/W=DistandMinis  WMini
			else
				wavestats/Q/R=[22,26] WMini
				WMini-=V_AVG		
				//appendtograph/W=ConsecutiveMinis  WMini
				consecutives+=1
			endif
		endif
		
		variable BL_SD = V_AVG+(V_sdev*3) /// second THERSHOLD!
		
		wavestats/Q/R=[27,32] WMini
		if (V_Max>=BL_SD)
			WdFMinis[x] = V_Max
			MiniTime[x] = WLevels[x]*dX
			appendtograph/W= MinisTemporal  WMini
			
		else
			WLevels [x]= Nan
			WValues[x] = Nan
		endif
	endfor
	
	String/G listofwaves = wavelist("*",";","WIN:MinisTemporal")
	string NameforNewWave = "ALLMinis_Btn"+num2str(btn)
	
	concatenate/NP=1/o listofwaves, $"Minis_dF_Btn"+num2str(btn)
	wave Wminis  = $"Minis_dF_Btn"+num2str(btn)
	
	doWindow/K MinisTemporal
	Display/k =1/N= $WindowName
	
	variable minisNum = (dimsize(Wminis, 1)
	variable y
	
	for (y = 0; y<=minisNum;y+=1)
		appendtograph/W= $WindowName  Wminis[][y]
	endfor
	
	averageTempWaves(NameforNewWave)
	appendtograph/W= $WindowName  $NameforNewWave+"_AVG"
	ModifyGraph lsize($NameforNewWave+"_AVG")=2,rgb($NameforNewWave+"_AVG")=(0,0,0)
	Label left "dF";DelayUpdate
	Label bottom "seconds"
	
	PPTDoKillMultipleWaves ("WOut", 1)
	
	WaveTransform/O zapNaNs, WValues
	WaveTransform/O zapNaNs, WLevels	
	WaveTransform/O zapNaNs, MiniTime
	WaveTransform/O zapNaNs, WdFMinis
	
	concatenate/DL/O/NP=1 {WLevels, WValues,MiniTime, WdFMinis}, $"Coor_Btn"+num2str(btn)
	variable/G NoEvents = dimsize($"Coor_Btn"+num2str(btn),0)
end

///////////////////////////////////
/////////////////////////////////////////////////////////

Function averageTempWaves(NameforNewWave)
    String NameforNewWave

    String/G listofwaves //= WaveList("WOut*", ";", "")
    fWaveAverage(listofwaves, "", 3, 1, NameforNewWave+"_AVG", NameforNewWave+"_SE")
end
	
////////////////////////////////////////////////////////////////
	
	 
