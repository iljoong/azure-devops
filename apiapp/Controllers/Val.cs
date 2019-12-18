using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace apiapp
{
    public class Val
    {
        public Val()
        {

        }

        public int New()
        {
            Random rand = new Random();
            int val = rand.Next(0, 100);
            return val;
        }
    }
}