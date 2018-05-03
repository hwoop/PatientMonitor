using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PatientMonitor.ExternalManager.Waveform;

namespace PatientMonitor.ExternalManager
{
    public static class CommunicationManager
    {
        /// <summary>
        /// Manage external interface's instance.
        /// </summary>
        static CommunicationManager()
        {
            waveformLock = new object();
        }

        static private object waveformLock;
        static private WaveformBase waveformManager;
        static public WaveformBase WaveformManager
        {
            get
            {
                lock (waveformLock)
                {
                    if (waveformManager == null)
                    {
                        // Condition will be changed if waveformManager have to provide the other Chart.
                        if (true)
                        {
                            waveformManager = new Waveform.ECG.ECGManager();
                        }
                    }
                    return waveformManager;
                }
            }
        }
        
    }
}
