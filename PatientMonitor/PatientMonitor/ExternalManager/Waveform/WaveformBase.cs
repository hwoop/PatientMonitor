using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PatientMonitor.ExternalManager.Waveform
{
    public abstract class WaveformBase
    {
        #region abstract method
        public abstract void Draw();
        public abstract void TryConnection();
        public abstract void Disconnect();
        #endregion
    }
}
