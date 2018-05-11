using Microsoft.Win32;
using PatinerMonitor.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Threading;

namespace PatinerMonitor
{
    /// <summary>
    /// MainWindow.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class MainWindow : Window
    {
        DateTime timeStarted;
        DispatcherTimer GetDataTimer = new DispatcherTimer();

        WaveformManager ECG;
        WaveformManager PPG;

        Simulator sim_ecg;
        Simulator sim_ppg;

        const int THRESHOLD = 250;

        public MainWindow()
        {
            InitializeComponent();

            SetTimer();
        }

        private void SetTimer()
        {
            timeStarted = DateTime.Now;
            GetDataTimer.Interval = TimeSpan.FromMilliseconds(10);
            GetDataTimer.Tick += timer_Tick;
            GetDataTimer.Start();
        }

        private void timer_Tick(object sender, EventArgs e)
        {
            if (ECG != null)
            {
                double ecg_data = sim_ecg.GetData();
                ECG.Draw(ActualHeight - ecg_data - THRESHOLD);
            }
            if (PPG != null)
            {
                double ppg_data = sim_ppg.GetData();
                PPG.Draw(ActualHeight - ppg_data*10 - THRESHOLD + 60);
            }
        }

        private void btnBrowseECG_Click(object sender, RoutedEventArgs e)
        {
            GetDataTimer.Stop();

            if (ECG != null)
            {
                ECG.Children.Clear();
                ECG.Loaded -= ECG_Loaded;
                ECG = null;
            }
                
            ECG = new WaveformManager();
            ecgGrid.Children.Add(ECG);
            ECG.Loaded += ECG_Loaded;

            sim_ecg = new Simulator(Simulator.WaveformType.ECG);

            OpenFileDialog ofd = new OpenFileDialog();
            ofd.Filter = "(CSV Files)|*.csv";
            ofd.Multiselect = false;

            if (ofd.ShowDialog() == true)
            {
                sim_ecg.LoadCSV(ofd.FileName);
            }

            GetDataTimer.Start();
        }

        private void btnBrowsePPG_Click(object sender, RoutedEventArgs e)
        {
            GetDataTimer.Stop();

            if (PPG != null)
            {
                PPG.Children.Clear();
                PPG.Loaded -= PPG_Loaded;
                PPG = null;
            }

            PPG = new WaveformManager();
            ppgGrid.Children.Add(PPG);
            PPG.Loaded += PPG_Loaded;

            sim_ppg = new Simulator(Simulator.WaveformType.PPG);

            OpenFileDialog ofd = new OpenFileDialog();
            ofd.Filter = "(CSV Files)|*.csv";
            ofd.Multiselect = false;

            if (ofd.ShowDialog() == true)
            {
                sim_ppg.LoadCSV(ofd.FileName);
            }

            GetDataTimer.Start();
        }
        private void ECG_Loaded(object sender, RoutedEventArgs e)
        {
            ECG.Init(1);
        }

        private void PPG_Loaded(object sender, RoutedEventArgs e)
        {
            PPG.Init(0.2);
        }
    }
}
