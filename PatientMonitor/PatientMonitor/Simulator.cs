using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PatinerMonitor
{
    public class Simulator
    {
        public enum WaveformType
        {
            ECG = 1,
            PPG = 2
        }

        private WaveformType CurrWaveformType;

        double[] ecg_data = new double[101];
        double[] ppg_data = new double[129];

        public Simulator(WaveformType dataType)
        {
            CurrWaveformType = dataType;
            switch (CurrWaveformType)
            {
                case WaveformType.ECG:
                    for (int i = 0; i < ecg_data.Length; i++)
                    {
                        ecg_data[i] = 0.0d;
                    }
                    break;
                case WaveformType.PPG:
                    for (int i = 0; i < ppg_data.Length; i++)
                    {
                        ppg_data[i] = 0.0d;
                    }
                    break;
            }
        }

        public void LoadCSV(string path)
        {
            try
            {
                using (var reader = new StreamReader(path))
                {
                    List<double> list = new List<double>();
                    while (!reader.EndOfStream)
                    {
                        list.Add(Convert.ToDouble(reader.ReadLine()));
                    }

                    if (CurrWaveformType == WaveformType.ECG)
                    {
                        for (int i = 0; i < list.Count; i++)
                        {
                            ecg_data[i] = list[i];
                        }
                    }
                    else if (CurrWaveformType == WaveformType.PPG)
                    {
                        for (int i = 0; i < list.Count; i++)
                        {
                            ppg_data[i] = list[i];
                        }
                    }
                    
                }
            }
            catch
            {
            }
        }

        private int loop = -1;
        public double GetData()
        {
            if (CurrWaveformType == WaveformType.ECG)
            {
                loop = loop > 98 ? 0 : loop + 1;
                return ecg_data[loop];
            }
            else if (CurrWaveformType == WaveformType.PPG)
            {
                loop = loop > 127 ? 0 : loop + 1;
                return ppg_data[loop];
            }
            else
                return 0.0d;
        }
    }
}
