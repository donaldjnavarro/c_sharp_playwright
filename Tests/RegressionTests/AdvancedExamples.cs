using NUnit.Framework;
using Microsoft.Playwright;
using System.Threading.Tasks;
using System.IO;

namespace RegressionTests
{
    [TestFixture]
    public class PlaywrightProofOfConceptTests
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

        [Test]
        public async Task ShouldLoadExampleDotCom()
        {
            await _page.GotoAsync("https://example.com");
            Assert.That(await _page.TitleAsync(), Is.EqualTo("Example Domain"));
        }

        [Test]
        public async Task ShouldFillFormInputs()
        {
            await _page.GotoAsync("https://www.w3schools.com/html/html_forms.asp");

            await _page.FillAsync("input[name='firstname']", "John");
            await _page.FillAsync("input[name='lastname']", "Doe");

            await _page.ScreenshotAsync(new PageScreenshotOptions
            {
                Path = "form_filled.png"
            });

            await _page.ClickAsync("input[type='submit']");

            Assert.Pass("Form filled and submitted (test placeholder)");
        }

        [Test]
        public async Task ShouldWaitAndAssertElementText()
        {
            await _page.GotoAsync("https://example.com");

            var h1 = await _page.WaitForSelectorAsync("h1");
            Assert.That(await h1.InnerTextAsync(), Is.EqualTo("Example Domain"));
        }

        [Test]
        public async Task ShouldHandleJsAlert()
        {
            await _page.GotoAsync("https://the-internet.herokuapp.com/javascript_alerts");

            _page.Dialog += async (_, dialog) =>
            {
                Assert.That(dialog.Type, Is.EqualTo("alert"));
                Assert.That(dialog.Message, Is.EqualTo("I am a JS Alert"));
                await dialog.AcceptAsync();
            };

            await _page.ClickAsync("button[onclick='jsAlert()']");
        }

        [Test]
        public async Task ShouldEmulateMobileDevice()
        {
            var iphone = _playwright.Devices["iPhone 12"];
            await _context.CloseAsync();

            _context = await _browser.NewContextAsync(iphone);
            _page = await _context.NewPageAsync();

            await _page.GotoAsync("https://example.com");

            var viewport = _page.ViewportSize;
            Assert.That(viewport?.Width, Is.LessThanOrEqualTo(400));
        }

        [Test]
        public async Task ShouldDownloadFile()
        {
            await _page.GotoAsync("https://file-examples.com/index.php/sample-documents-download/sample-pdf-download/");

            var download = await _page.RunAndWaitForDownloadAsync(async () =>
            {
                await _page.ClickAsync("a[href*='file_example_PDF_1MB.pdf']");
            });

            var path = await download.PathAsync();

            // Ensure file exists
            Assert.That(File.Exists(path), Is.True, "Download file does not exist.");
            Assert.That(path, Does.EndWith(".pdf"));
        }

        [TearDown]
        public async Task Teardown()
        {
            await _context.CloseAsync();
            await _browser.CloseAsync();
            _playwright.Dispose();
        }
    }
}
