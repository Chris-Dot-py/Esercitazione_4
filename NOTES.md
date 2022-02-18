# things to fix
1. Find out if there is a better way to manage spi master clock.
2. Each Standard_Discrete_Interface<n>, shall store AT LEAST the data reported in Figure 7 (numbers expressed in samples).
   - CHE SUCCEDE SE NE IMMAGAZZINA PIù DI 10 E NEL PACCHETTO NE TRASMETTE SOLO 10? IL
     RESTO VIENE CONGELATO E TRASFERITO NELL'ALTRO BUFFER?
3. When send_snf_data is received as changing from '0' to '1', each  Standard_Discrete_Interface<n> shall freeze the acquired data.
   - CONGELO IL BUFFER DA SCARICARE E SALVO INTANTO NELL'ALTRO?

   - ciascun canale può essere un input o output, quando è posto come output non va saltata durante il processo
     della composizione del pacchetto

3.A. While the data are frozen, each  Standard_Discrete_Interface<n>, Negative_Discrete_Interface<n>, Filtered_Discrete_Interface<n>
     Fast_Discrete_Interface<n> shall store new incoming data. Those data will be sent in the next packet.
     - CONGELO il BUFFER DA SCARICARE E SALVO NELL'ALTRO BUFFER?


4. When the outgoing packet is sent, each Standard_Discrete_Interface<n>, can overwrite the now obsolete data, providing not to     
   send any of the obsolete data in the next packet.
   - WHEN IS DATA OBSOLETE?

5. Per ora ho impostato il canale con due linee separate in per holt, out per fpga_o 
