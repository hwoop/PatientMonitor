using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Shapes;

namespace PatinerMonitor.Model
{
    public class WaveformManager : Canvas, IWaveformInterface, INotifyPropertyChanged
    {
        #region Variables
        // x is the general keyword representing time axis, so used lower case.
        private double prevX, prevY;
        private double x;
        public double Speed;
        #endregion

        #region PropertyChanged
        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(string name)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }
        #endregion

        public WaveformManager()
        {

        }

        public void Init(double speed = 1)
        {
            prevX = x = ActualWidth;
            prevY = ActualHeight / 2;
            Speed = speed;
        }

        #region Implementation Interface
        public void Draw(double y)
        {
            try
            {
                if (x >= ActualWidth)
                {
                    x = 0;
                    Children.Clear();
                }

                Line line = new Line();
                line.Stroke = System.Windows.Media.Brushes.Black;
                line.StrokeThickness = 1;

                line.X1 = x;
                x += 1 * Speed;
                line.Y1 = prevY;

                line.X2 = x;
                line.Y2 = y;

                prevY = y;

                Children.Add(line);
            }
            catch (Exception ex)
            {

            }
        }

        public void TryConnection()
        {
        }

        public void Disconnect()
        {
        }
        #endregion
    }
}
