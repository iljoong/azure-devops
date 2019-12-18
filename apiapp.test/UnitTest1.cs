using Microsoft.VisualStudio.TestTools.UnitTesting;
using apiapp;

namespace apiapptest
{
    [TestClass]
    public class ApiAppTest
    {
        private readonly Val _val;

        public ApiAppTest()
        {
            _val = new Val();
        }

        [TestMethod]
        public void TestMethod1()
        {
            var ret = _val.New();

            Assert.IsTrue((ret > 0 && ret < 100), $"Value is out of range and value was {ret}");
        }
    }
}
