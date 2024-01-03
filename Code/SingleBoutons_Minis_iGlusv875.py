from ij import IJ, ImagePlus
from ij import WindowManager as WM 
from ij.plugin.frame import RoiManager
from ij.gui import Roi, Plot
from ij.measure import Measurements, ResultsTable
from ij.io import FileSaver 
import os

###### Setup Val ####
xVal=  1600  ##1600 ##1250 ## x value to click in Get Avg
yVal =  229 ##229 ##240 

#####

Date = 210511
Cell = 1
Type = 0 ## 0 = WT; 1 = TeTN; 2 = M13KD

Calibration = 4 ### 0 = NH4Cl; 1 = Minis; 2= 100AP10Hz; 4=SaveROIs
step = 0	## 0 = Initial; 1= after20min 

Concentration = ""
MinisCtrl = 6
MinisSuc = 0

#############################################
##### NAMES ################################
if Type == 0:
	CellType = ""

if Type == 1:
	CellType = "_M13KD"
####################
########################
##FolderOUT = "/home/camila/Dropbox/LABORATORY/ANALYSIS/iGluSnFR/iGlus_v875/2021/perBouton/"+str(Date)+"_C"+str(Cell)+"/"
##FolderIN = "/home/camila/Dropbox/LABORATORY/DATA/iGluSnFR/iGlus_v875/2021/"+str(Date)+"/C"+str(Cell)+"/"

FolderOUT = "C:\\Users\\cmp2010\\Dropbox\\LABORATORY\\ANALYSIS\\iGluSnFR\\iGlus_v875\\2021\\perBouton\\"+str(Date)+"_C"+str(Cell)+"\\"
FolderIN = "C:\\Users\\cmp2010\\Dropbox\\LABORATORY\\DATA\\iGluSnFR\\iGlus_v875\\2021\\"+str(Date)+"\\C"+str(Cell)+"\\"


if not os.path.exists(FolderOUT):
    os.makedirs(FolderOUT)

###################
########GLUTAMATE CALIBRATION ###########

if Calibration == 0:
	NameOut = str(Date)+"_C"+str(Cell)+CellType+"_Gluta100mM"
	path2 = FolderOUT+NameOut+"_Btns.xls"
	IJ.renameResults("Time Trace(s)", "Results")
	IJ.saveAs("Results", path2)
	Results2 = ResultsTable.getResultsTable()
	AVG = Results2.getColumn(Results2.getColumnIndex("Average"))
	Results = ResultsTable() 
		
	for i in range(len(AVG)): 
       	 Results.incrementCounter() 
         Results.addValue('Mean', AVG[i])

	Results.show('Mean')
	path= FolderOUT+NameOut+".txt"
	Results.saveAs(path)

################################
####### SINGLE APs ##################

if Calibration == 1:
	for cycle in range(step,step+1):
		if cycle == 0:
			Step = ""
			Total = MinisCtrl
		if cycle == 1:
			Step = "_Suc500mM"
			Total = MinisSuc
	
		Name = "C"+str(Cell)+CellType+"_MinisTTx"+Step
	
 		for APs in range(0,Total):
 			if APs == 0:
 				NameIN = Name
 				NameOUT = str(Date)+"_"+Name+"_0"
 				NameOUT1 = str(Date)+"_"+Name+"_0_Btns"
 			if APs!= 0:
 				NameIN = Name+"_"+str(APs)
				NameOUT = str(Date)+"_"+Name+"_"+str(APs) 
				NameOUT1 = str(Date)+"_"+Name+"_"+str(APs)+"_Btns"
				
 			path = FolderIN+NameIN+".fits"
 			pathOut1 = FolderOUT+NameOUT1+".xls"
			imp = IJ.openImage(path)
			imp.show()

			imp = IJ.run(imp, "Z Project...", " projection=[Average Intensity]")
			for x in range(0,1000000):
				x=x
				
			imp = IJ.selectWindow("AVG_"+NameIN+".fits")
			imp = IJ.getImage()
					 
			IJ.run("IJ Robot", "order=Left_Click x_point="+str(xVal)+" y_point=180 delay=100 keypress=[]") ## RECENTER
			#IJ.run("IJ Robot", "order=Left_Click x_point=1600 y_point=185 delay=10 keypress=[]") ## RECENTER

			for x in range(0,10000000):
				x=x
			
			imp = IJ.selectWindow("AVG_"+NameIN+".fits")
			imp = IJ.getImage()
			imp.close()
			
			imp = IJ.selectWindow(NameIN+".fits")
			imp = IJ.getImage()			
		
			for x in range(0,10000000):
				x=x
		
			IJ.run("IJ Robot", "order=Left_Click x_point="+str(xVal)+" y_point="+str(yVal)+" delay=50 keypress=[]") ## GET AVG

			for x in range(0,10000000):
				x=x
		
			IJ.renameResults("Time Trace(s)", "Results")
			IJ.saveAs("Results", pathOut1)
			
			Results2 = ResultsTable.getResultsTable()
			AVG = Results2.getColumn(Results2.getColumnIndex("Average"))
			Results = ResultsTable() 
		
			for i in range(len(AVG)): 
   				Results.incrementCounter() 
   	 			Results.addValue('Mean', AVG[i])

			Results.show('Mean')
			pathOut= FolderOUT+NameOUT+".txt"
			Results.saveAs(pathOut)
			

			path2 = FolderOUT+"Info_MinisTTx_"+str(APs)+".txt"
			IJ.selectWindow(NameIN+".fits")
			imp=  IJ.getImage()
			IJ.run(imp, "Show Info...", "")
	
			print("\\Clear")
			IJ.selectWindow("Info for "+NameIN+".fits")
			IJ.saveAs("Text",path2)
			imp.close()
###################################
######### SATURATION STIM ###############

if Calibration == 2:
	for cycle in range(step,step+1):
		if cycle == 0: 
			NameIN = "C"+str(Cell)+CellType+"_AP"
			NameOUT = str(Date)+"_"+NameIN
			NameOUT1 = str(Date)+"_"+NameIN+"_Btns"
		if cycle == 1:
			NameIN= "C"+str(Cell)+CellType+"_AP_TTx"
			NameOUT = str(Date)+"_"+NameIN
			NameOUT1 = str(Date)+"_"+NameIN+"_Btns"
		
		path = FolderIN+NameIN+".fits"
		pathOut1 = FolderOUT+NameOUT1+".xls"
		imp = IJ.openImage(path)
		imp.show()
		
		imp = IJ.selectWindow(NameIN+".fits")
		imp = IJ.getImage()			
		
		for x in range(0,10000000):
			x=x
		
		IJ.run("IJ Robot", "order=Left_Click x_point="+str(xVal)+" y_point="+str(yVal)+" delay=50 keypress=[]")  ## GET AVG
	
		for x in range(0,10000000):
			x=x
	
		IJ.renameResults("Time Trace(s)", "Results")
		IJ.saveAs("Results", pathOut1)
			
		Results2 = ResultsTable.getResultsTable()
		AVG = Results2.getColumn(Results2.getColumnIndex("Average"))
		Results = ResultsTable() 
		
		for i in range(len(AVG)): 
   			Results.incrementCounter() 
   	 		Results.addValue('Mean', AVG[i])

		Results.show('Mean')
		pathOut= FolderOUT+NameOUT+".txt"
		Results.saveAs(pathOut)
		imp.close()			

######### Close windows and Save ROIs ###############

rm = RoiManager.getInstance()
ROISPath = FolderIN
if Calibration == 4:
	rm.runCommand("deselect") 
	rm.runCommand("save", os.path.join(ROISPath, "ROIs.zip")) 
	rm.runCommand("Delete")

