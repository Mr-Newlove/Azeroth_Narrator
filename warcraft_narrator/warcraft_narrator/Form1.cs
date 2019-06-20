using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.Linq;
using System.Runtime.InteropServices;
using System.Speech.AudioFormat;
using System.Speech.Synthesis;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace warcraft_narrator
{

    public partial class Form1 : Form
    {
        int local_index = -1;
        int new_index = -1;
        Bitmap bitmap = new Bitmap(600, 1);
        Rectangle bounds;
        Graphics g;
        char prev_R = '\0';
        char prev_G = '\0';
        char prev_B = '\0';
        char cur_R = '\0';
        char cur_G = '\0';
        char cur_B = '\0';
        string last_valid_string = "";
        SpeechSynthesizer synthesizer;
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            g = Graphics.FromImage(bitmap);

            synthesizer = new SpeechSynthesizer
            {
                Volume = 100,  // 0...100
                Rate = 1,     // -10...10

            };
        }

        private void Form1_Shown(object sender, EventArgs e)
        {
            timer1.Enabled = true;
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            timer1.Enabled = false;
            label1.Text = "";
            bounds = Screen.GetBounds(Point.Empty);
            g.CopyFromScreen(Point.Empty, Point.Empty, bounds.Size);
            for (int y = 0; y < bitmap.Height; y++)
            {
                for (int x = 0; x < bitmap.Width; x++)
                {
                    cur_R = Convert.ToChar((byte)Math.Round(((bitmap.GetPixel(x, y).R / 255.0) * 100.0) + 30));
                    cur_G = Convert.ToChar((byte)Math.Round(((bitmap.GetPixel(x, y).G / 255.0) * 100.0) + 30));
                    cur_B = Convert.ToChar((byte)Math.Round(((bitmap.GetPixel(x, y).B / 255.0) * 100.0) + 30));
                    if (prev_R == cur_R && prev_G == cur_G && prev_B == cur_B) continue;
                    if (!((byte)cur_R >= 32 && (byte)cur_R <= 126)) continue;
                    if (!((byte)cur_G >= 32 && (byte)cur_G <= 126)) continue;
                    if (!((byte)cur_B >= 32 && (byte)cur_B <= 126)) continue;
                    label1.Text += "" + cur_R;
                    label1.Text += "" + cur_G;
                    label1.Text += "" + cur_B;
                    prev_R = cur_R;
                    prev_G = cur_G;
                    prev_B = cur_B;

                }
            }
            if (!label1.Text.StartsWith("WoW("))
            {
                label1.Text = "";
            }
            else
            {

                new_index = Convert.ToInt32(label1.Text.Substring(label1.Text.IndexOf("(") + 1, label1.Text.IndexOf(")") - (label1.Text.IndexOf("(") + 1)));
                label1.Text = label1.Text.Substring(label1.Text.IndexOf("{")+1);
                label1.Text = label1.Text.Substring(0, label1.Text.LastIndexOf("}"));
                if (local_index != new_index)
                {
                    local_index = new_index;
                    last_valid_string = label1.Text;
                    synthesizer.Speak(last_valid_string);
                }

            }
            timer1.Enabled = true;
        }
    }
}