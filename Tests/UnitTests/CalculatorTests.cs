using NUnit.Framework;
using MyApp;

namespace UnitTests
{
    public class CalculatorTests
    {
        [Test]
        public void Add_ShouldReturnCorrectSum()
        {
            var calc = new Calculator();
            var result = calc.Add(2, 3);
            Assert.AreEqual(5, result);
        }

        [Test]
        public void Multiply_ShouldReturnCorrectProduct()
        {
            var calc = new Calculator();
            var result = calc.Multiply(4, 5);
            Assert.AreEqual(20, result);
        }
    }
}
