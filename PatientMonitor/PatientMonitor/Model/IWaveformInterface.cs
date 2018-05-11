using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PatinerMonitor.Model
{
    public interface IWaveformInterface
    {
        #region View method
        void Draw(double y);
        #endregion

        #region Communication method
        void TryConnection();
        void Disconnect();
        #endregion
    }
}
