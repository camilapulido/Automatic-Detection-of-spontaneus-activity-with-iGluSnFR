from ij import IJ, ImagePlus
from ij import WindowManager as WM 
from ij.plugin.frame import RoiManager
from ij.gui import Roi, Plot
from ij.measure import Measurements, ResultsTable
from ij.io import FileSaver
 
import os
xVal= 1600 ##1250 ## x value to click in Get Avg
yVal = 229 ##240


Date = 210326
Cell = 2
Type = 1 ## 0 = WT; 1 = TeTN; 2 = M13KD

Calibration = 2 ### 1 == Single APs

MinisCtrl = 3
MinisSuc = 0

#############################################
##### NAMES ################################
if Type == 0:
	CellType = ""
if Type == 1:
	CellType = "_M13KDBFP"
####################
########################
##FolderOUT = "/home/camila/Dropbox/LABORATORY/ANALYSIS/VGlut_pH/Minis/2021/perBouton/"+str(Date)+"_C"+str(Cell)+"/"
##FolderIN = "/home/camila/Dropbox/LABORATORY/DATA/vGlut_pH/2021/"+str(Date)+"/C"+str(Cell)+"/"

FolderOUT = "C:\\Users\\cmp2010\\Dropbox\\LABORATORY\\ANALYSIS\\VGlut_pH\\Minis\\2021\\perBouton\\"+str(Date)+"_C"+str(Cell)+"\\"
FolderIN = "C:\\Users\\cmp2010\\Dropbox\\LABORATORY\\DATA\\VGlut_pH\\2021\\"+str(Date)+"\\C"+str(Cell)+"\\"

if not os.path.exists(FolderOUT):
    os.makedirs(FolderOUT)

if Calibration == 0:
	NameIN = "C"+str(Cell)+CellType+"_NH4Cl"
	NameOUT = str(Date)+"_"+NameIN+"_Black"
		
	path = FolderIN+NameIN+".fits"
	imp = IJ.openImage(path)
	imp.show()
	for x in range(0,10000000):
		x=x
	IJ.run("IJ Robot", "order=Left_Click x_point="+str(xVal)+" y_point="+str(yVal)+" delay=200 keypress=[]");
	for x in range(0,10000000):
		x=x
	IJ.renameResults("Time Trace(s)", "Results") 
	Results2 = ResultsTable.getResultsTable()
	AVG = Results2.getColumn(Results2.getColumnIndex("Average"))
	Results = ResultsTable() 
	for i in range(len(AVG)): 
   		Results.incrementCounter() 
   	 	Results.addValue('Mean', AVG[i])

	Results.show('Mean')
	path= FolderOUT+NameOUT+".txt"
	Results.saveAs(path)

	imp.close()

if Calibration == 1:
	for cycle in range(0,1):
		if cycle ==0:
			Step = ""
			Total = MinisCtrl
		if cycle == 1:
			Step = "Suc500mM"
			Total = MinisSuc
	
		Name = "C"+str(Cell)+CellType+"_MinisTTx"+Step
	
 		for APs in range(0,Total):
 			if APs == 0:
 				NameIN = Name
 				NameOUT = str(Date)+"_"+Name+"_0_Black"
 			if APs!= 0:
 				NameIN = Name+"_"+str(APs)
				NameOUT = str(Date)+"_"+NameIN+"_Black"
			
 			path = FolderIN+NameIN+".fits"
			imp = IJ.openImage(path)
			imp.show()

			for x in range(0,10000000):
				x=x
			
			IJ.run("IJ Robot", "order=Left_Click x_point="+str(xVal)+" y_point="+str(yVal)+" delay=200 keypress=[]"); ## GET AVG

			for x in range(0,10000000):
				x=x
		
			IJ.renameResults("Time Trace(s)", "Results") 
			Results2 = ResultsTable.getResultsTable()
			AVG = Results2.getColumn(Results2.getColumnIndex("Average"))
			Results = ResultsTable() 
		
			for i in range(len(AVG)): 
   				Results.incrementCounter() 
   	 			Results.addValue('Mean', AVG[i])

			Results.show('Mean')
			path= FolderOUT+NameOUT+".txt"
			Results.saveAs(path)
			imp.close()
			
if Calibration == 2:
	for cycle in range(0,2):
		if cycle == 0: 
			NameIN = "C"+str(Cell)+CellType+"_10Hz100AP"
			NameOUT = str(Date)+"_"+NameIN+"_Black"
		if cycle == 1:
			NameIN= "C"+str(Cell)+CellType+"_TTx_10Hz100AP"
			NameOUT = str(Date)+"_"+NameIN+"_Black"
		
		path = FolderIN+NameIN+".fits"
		imp = IJ.openImage(path)
		imp.show()
		for x in range(0,10000000):
			x=x
		IJ.run("IJ Robot", "order=Left_Click x_point="+str(xVal)+" y_point="+str(yVal)+" delay=200 keypress=[]");
		for x in range(0,10000000):
			x=x
		IJ.renameResults("Time Trace(s)", "Results") 
		Results2 = ResultsTable.getResultsTable()
		AVG = Results2.getColumn(Results2.getColumnIndex("Average"))
		Results = ResultsTable() 
		for i in range(len(AVG)): 
	   		Results.incrementCounter() 
	   	 	Results.addValue('Mean', AVG[i])
	
		Results.show('Mean')
		path= FolderOUT+NameOUT+".txt"
		Results.saveAs(path)
	
		imp.close()

