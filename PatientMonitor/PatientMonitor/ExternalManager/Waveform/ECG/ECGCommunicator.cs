using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PatientMonitor.ExternalManager.Waveform.ECG
{
    public class ECGCommunicator
    {
        SerialPort ECGPort;

        public ECGCommunicator()
        {

        }

        public void Connect()
        {
            try
            {
                string portName = "COM1";
                int baudRate = 115200;

                if (ECGPort == null)
                    ECGPort = new SerialPort(portName, baudRate);

                if (ECGPort.IsOpen == false)
                    ECGPort.Open();
            }
            catch
            {

            }
        }

        public void Disconnect()
        {
        }

        private void OpenSocket()
        {
        }

        private void CloseSocket()
        {
        }
    }
}
