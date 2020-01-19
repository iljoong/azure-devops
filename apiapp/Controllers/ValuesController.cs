using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using apiapp;
using Microsoft.Extensions.Configuration;

namespace apiapp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ValuesController : ControllerBase
    {
        string teststring;
        string sqlconn;

        public ValuesController(IConfiguration _config)
        {
            // print all config
            /*foreach(var conf in _config.AsEnumerable())
            {
                Console.WriteLine($"Trace: Config: {conf.Key}:{conf.Value}");
            }*/

            // get config
            teststring = _config["app:teststring"] ?? "NO VALUE SET";
            sqlconn = _config["app:sqlconn"] ?? "NO VALUE SET";
        }

        // GET api/values
        [HttpGet]
        public ActionResult<IEnumerable<string>> Get()
        {
            Val v = new Val();

            return new string[] { $"values{v.New()}", $"values{v.New()}" };
        }

        [HttpGet("/health")]
        public ActionResult<string> Health()
        {
            return "okay";
        }

        [HttpGet("/test")]
        public ActionResult<string> Test()
        {
            return teststring;
        }

        [HttpGet("/sql")]
        public ActionResult<string> Sql()
        {
            return sqlconn;
        }

        // GET api/values/5
        [HttpGet("{id}")]
        public ActionResult<string> Get(int id)
        {
            return "value";
        }

        // POST api/values
        [HttpPost]
        public void Post([FromBody] string value)
        {
        }

        // PUT api/values/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/values/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
