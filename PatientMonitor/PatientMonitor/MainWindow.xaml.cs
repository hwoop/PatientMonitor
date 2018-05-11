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

        public MainWindow()
        {
            InitializeComponent();

            ECG = new WaveformManager();
            myGrid.Children.Add(ECG);
            ECG.Loaded += ECG_Loaded;

            SetTimer();
        }

        private void ECG_Loaded(object sender, RoutedEventArgs e)
        {
            ECG.Init(2);
        }

        private void SetTimer()
        {
            timeStarted = DateTime.Now;
            GetDataTimer.Interval = TimeSpan.FromMilliseconds(50);
            GetDataTimer.Tick += timer_Tick;
            GetDataTimer.Start();
        }

        private void timer_Tick(object sender, EventArgs e)
        {
            var rand = new Random();
            ECG.Draw(((rand.Next() % 100) + 50));
        }
    }
}
