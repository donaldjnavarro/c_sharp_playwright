using NUnit.Framework;
using Microsoft.Playwright;
using System.Threading.Tasks;

namespace RegressionTests
{
    [TestFixture]
    public class ExampleTests
    {
        private IPlaywright _playwright = null!;
        private IBrowser _browser = null!;
        private IPage _page = null!;

        [SetUp]
        public async Task Setup()
        {
            _playwright = await Playwright.CreateAsync();
            _browser = await _playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions { Headless = true });
            _page = await _browser.NewPageAsync();
        }

        [Test]
        public async Task ShouldLoadExamplePage()
        {
            await _page.GotoAsync("https://example.com");
            Assert.That(await _page.TitleAsync(), Is.EqualTo("Example Domain"));
        }

        [TearDown]
        public async Task Teardown()
        {
            await _browser.CloseAsync();
            _playwright.Dispose();
        }
    }
}
