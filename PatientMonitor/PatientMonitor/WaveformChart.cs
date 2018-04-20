using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PatientMonitor
{
    public class WaveformChart : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(string name)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(name));
            }
        }

        public enum ChartType
        {
            ECG,
            PPG,
            NIBP_AC,
            NIBP_DC
        }



        public ChartType myChartType;
        public WaveformChart(ChartType chartType)
        {
            myChartType = chartType;
            UpdateUI();
        }

        public string StringChartType
        {
            get
            {
                return nameof(myChartType.);
            }
        }

        void UpdateUI()
        {
            //NotifyPropertyChanged("StringChartType");
        }
    }
}
