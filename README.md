This project includes old code that Jeremiah Wander wrote before TDT developed their own conversion scripts. His code still works, but does not convert epoch or block stores (possibly other data types as well). 
Since then, **TDT has updated their TDT2mat.m function** which will convert all stored data types and save them in one large struct. That struct contains all of the data we need but it's internal structure is not compatible with our current code because it's different than what was originally created. 
**ConvertTDTRecordingToMAT_v2.m acts as a wrapper around TDT's function** to first create their large data struct, then open it up, and build smaller substructs that are structured like we're used to. This should work with all data store types, including epochs and block stores now.   
  
This project also includes a folder with examples from TDT, a development folder, and a folder that contains all of the original conversion scripts which Miah wrote.  
For Miah's code you would run ConverTDTRecordingToMAT.m which relies on mTDT2MAT and TTank. This still works, but shouldn't be used because it can't convert all data types.  
  
  
**The current code to use:**  
*ConvertTDTRecordingToMAT_v2*, explains what data types are generated and will save the resultant .mat file to a location of your choice  
This calls *changeStructNames.m* and *TDT2mat.m* which uses *SEV2mat* (the later two are from TDT)
  
Data types stored with this code:  
**Streams**  
*data is stored as samples x channels*   
  
  
**Scalars** (for slow stores)  
*data is stored as samples x channels*  
Slow stores can have internal sampling rates (which you set the machine to, ~1Hz), or external sampling rates based on a trigger. Because of this, the TDT Tank code will not compute a sampling rate for slow stores (i.e., the scalar type). Instead TDT returns a timing vector.  
    The *changeStructNames.m* script uses this timing vector to compute an approximate sampling rate and returns both.   
    timing vector: *____.info.ts*    
    frequency: *____.info.SamplingRateHz*  
    If the standard dev of the diff of the timing vector is <1e-5, then the code uses the mean of the diff of the timing vector to compute the sampling rate  
    However, if the std dev of the diff of the timing vector is greater than that allowed error, it will just return a warning and will set *___.info.SamplingRateHz = NaN*  
  
**Epocs**  
*data is stored as triggered samples x 1*  
Note that TDT calls this type Strobe+, but saves it under data.epocs in their large struct, so here it is saved as type 'epoc'  
  
**Snips** (for block stores)  
*data is stored as samples x channels x epochs*  
*dataRAW is stored as epochs x samples*   
    This is how TDT's TDT2mat.m function outputs the snip data (where epochs have channels mixed in). The channels can be separated from the epochs using the .chan field of the struct, which is done in the changeStructNames.m script and then output as the .data field  

