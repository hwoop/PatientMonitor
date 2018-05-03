using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PatientMonitor.ExternalManager.Waveform.ECG
{
    public class ECGManager :WaveformBase
    {
        #region Variables
        ECGCommunicator communicator;
        #endregion
        public ECGManager()
        {
        }

        public override void Draw()
        {
            throw new NotImplementedException();
        }

        public override void TryConnection()
        {
            try
            {
                if (communicator == null)
                    communicator = new ECGCommunicator();

                if (communicator != null)
                {
                    communicator.Connect();
                }
            }
            catch{ }
        }

        public override void Disconnect()
        {
            try
            {
                if (communicator != null)
                {
                    communicator.Disconnect();
                    communicator = null;
                }
            }
            catch { }
        }
    }
}
