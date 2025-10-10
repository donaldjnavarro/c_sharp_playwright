using NUnit.Framework;
using Microsoft.Playwright;
using System.Threading.Tasks;
using System.IO;

namespace RegressionTests
{
    [TestFixture]
    public class PlaywrightExamples
    {
        private IPlaywright _playwright = null!;
        private IBrowser _browser = null!;
        private IBrowserContext _context = null!;
        private IPage _page = null!;

        [SetUp]
        public async Task Setup()
        {
            _playwright = await Playwright.CreateAsync();
            _browser = await _playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions
            {
                Headless = true
            });

            _context = await _browser.NewContextAsync();
            _page = await _context.NewPageAsync();
        }

        [TearDown]
        public async Task Teardown()
        {
            await _page.CloseAsync();
            await _context.CloseAsync();
            await _browser.CloseAsync();
            _playwright.Dispose();
        }

        [Test]
        public async Task SimpleNavigationTest()
        {
            await _page.GotoAsync("https://example.com");
            string title = await _page.TitleAsync();
            Assert.AreEqual("Example Domain", title);
        }

        [Test]
        public async Task FillFormTest()
        {
            await _page.SetContentAsync(@"
                <form>
                    <input id='name' type='text'/>
                    <input id='submit' type='submit'/>
                </form>");

            await _page.FillAsync("#name", "Donald");
            string value = await _page.InputValueAsync("#name");
            Assert.AreEqual("Donald", value);
        }

        [Test]
        public async Task DownloadFileTest()
        {
            // Create a simple page with a downloadable blob
            await _page.SetContentAsync(@"
                <a id='downloadLink' download='test.txt' href='data:text/plain,Hello%20World'>Download</a>");

            string downloadPath = Path.Combine(Path.GetTempPath(), "test.txt");

            var download = await _page.RunAndWaitForDownloadAsync(async () =>
            {
                await _page.Locator("#downloadLink").ClickAsync();
            });

            await download.SaveAsAsync(downloadPath);
            Assert.IsTrue(File.Exists(downloadPath));

            string contents = await File.ReadAllTextAsync(downloadPath);
            Assert.AreEqual("Hello World", contents);

            File.Delete(downloadPath);
        }

        [Test]
        public async Task MultipleElementsTest()
        {
            await _page.SetContentAsync(@"
                <ul>
                    <li class='item'>One</li>
                    <li class='item'>Two</li>
                    <li class='item'>Three</li>
                </ul>");

            var items = _page.Locator(".item");
            Assert.AreEqual(3, await items.CountAsync());
        }
    }
}
