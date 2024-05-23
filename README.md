# Automatic detection of Spontaneous Synaptic Activity by the use of the glutamate sensor iGlusnFr.
Author: Camila Pulido

##
> [!NOTE]
>* This protocol delineates the analysis for the detection of spontaneous activity within synaptic boutons, employing the genetically engineered Glutamate sensors iGluSnFR, published [here](https://www.nature.com/articles/s41592-018-0171-3)
>* This protocol is intended to use two analysis programs: [ImageJ (Fiji)](https://fiji.sc/) and [IGOR Pro (wavemetrics)](https://www.wavemetrics.com/).

> [!IMPORTANT]
> * Prior to implementing this protocol, users need to customize the provided code to align with their individual settings.
> * Maintain consistent file naming formatting across all experiments.

## Image collection and preprocessing: 

Spontaneous glutamate release can be detected by the increase in fluorescent signal within synaptic boutons. The sample video bellow exemplified spontaneous activity in a synaptic bouton labeled with an arrow:

<img src="./Figures/Axon_SynapticBouton_SpontaneousRelease_Arrow3.gif" alt="BoutonActivity" style="width: 400px;"/>

Signal information corresponding to that specific bouton can be extracted and save by using ImageJ software and ['Time Series Analyzer'](https://imagej.net/ij/plugins/time-series.html) Plugin. Briefly simply place a round ROI in the desired bouton and Get signal in the corresponding ROI. 

<img src="./Figures/MiniExample_for Video.png" alt="BoutonTrace" style="width: 800px;"/>

Effortlessly extract and save signal information from every frame, by simply executing the ['Getting Boutons signal code'](Code/SingleBoutons_Minis_iGluSnFR.py), ensuring to save the selected ROIs for future reference (one of the steps in the code).

Import the signal information from all boutons, along with their corresponding background signals, into the IGOR-PRO program (wavemetrics), organizing them into matrix arrays for further analysis.

https://github.com/camilapulido/Automatic-Detection-of-spontaneus-activity-with-iGluSnFR/blob/c6e137f3950aa6ea50df106312a98c088a54ff57/Code/Igor_%20Spontaneous%20Events%20Detection.ipf#L4

Correct synaptic boutons signals by subtracting background noise:
https://github.com/camilapulido/Automatic-Detection-of-spontaneus-activity-with-iGluSnFR/blob/c6e137f3950aa6ea50df106312a98c088a54ff57/Code/Igor_%20Spontaneous%20Events%20Detection.ipf#L121

At this point, the data is organized and prepared for analysis!

## Spontaneous Activity Detection and spike Sorting:
Spontaneous glutamate release frequency can be increased by artificially changing the osmolarity of the neuron, for example by adding to 250mM of Sucrose:

<img src="./Figures/Minis_Trace_Example_NOmarks.png" alt="SucroseTrace" style="width: 1000px;"/>

[Execute Function](https://github.com/camilapulido/iGlusnFr-spontaneus-minis-detection/blob/a22b0a206a757ff2408505cf721da770b623df81/Code/Igor_%20Spontaneous%20Events%20Detection.ipf#L170) to automatically run a threshold analysis based on baseline signal noise (1.3xSD of AVG signal noise) and automatically detect fast spontaneous release of glutamate: 

<img src="./Figures/Minis_Trace_Example_marks.png" alt="SucroseTraceMarks" style="width: 1000px;"/>

Individual events will be automatically sorted and plotted together:

<img src="./Figures/Minis_superimposed.png" alt="Minis" style="width: 500px;"/>




