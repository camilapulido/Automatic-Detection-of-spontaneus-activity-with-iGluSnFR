# Automatic detection of Spontaneus Synaptic Activty by the use of the glutamete sensor iGlusnFr.
Author: Camila Pulido

##
> [!NOTE]
>* This protocol delineates the analysis for the detection of spontaneous activity within synaptic boutons, employing the genetically engineered Glutamate sensors iGluSnFR, published [here](https://www.biorxiv.org/content/10.1101/2023.08.24.554624v1)
>* This protocol is intended to use two analysis programs: [ImageJ (Fiji)](https://fiji.sc/) and [IGOR Pro (wavemetrics)](https://www.wavemetrics.com/).

> [!IMPORTANT]
> * Prior to implementing this protocol, users need to customize the provided code to align with their individual settings.
> * Maintain consistent file naming formatting across all experiments.

## Image collection and preprocessing: 

Spontaneous glutamate realease can be detected by the increase in fluorescent signal within synaptic boutons. The sample video bellow exemplified spontaneous activity in a synaptic bouton labeled with an arrow:

<img src="./Figures/Axon_SynapticBouton_SpontaneousRelease_Arrow3.gif" alt="BoutonActivity" style="width: 400px;"/>

Signal information corresponding to that specific bouton or multiple ones can be extracted and save by using ImageJ sofware and ['Time Series Analyzer'](https://imagej.net/ij/plugins/time-series.html) Plugin. Briefly simply place a round ROI in the desired bouton and Get signal in the corresponding ROI. 
