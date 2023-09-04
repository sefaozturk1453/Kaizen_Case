using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml.Linq;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace SaaSToText
{
    internal class Program
    {
        static void Main(string[] args)
        {
            string filePath = "response.json";

            // Dosyayı oku
            var jsonString = File.ReadAllText(filePath);

            jsonString = "{\r\n   \"items\":" + jsonString + "}";

            // Parse JSON to Root object
            Root rootObject = JsonConvert.DeserializeObject<Root>(jsonString);

            // Sırala
            var sortedItems = rootObject.items.OrderBy(item => item.boundingPoly.vertices.First().y).ToList();

            var count = 1;
            for (int i = 0; i < sortedItems.Count(); i = i + count)
            {
                var item = sortedItems[i];
                if (string.IsNullOrEmpty(item.locale))
                {
                    int currentY = item.boundingPoly.vertices.First().y;
                    var minY = currentY - 10;
                    var maxY = currentY + 10;

                    var line = sortedItems.Where(item => item.locale == null && item.boundingPoly.vertices.First().y >= minY && item.boundingPoly.vertices.First().y <= maxY).ToList();

                    count = line.Count;
                    line.ForEach(item =>
                    {
                        Console.Write(item.description + " ");
                    });
                    Console.WriteLine("");
                }
            }

        }
        public class Vertices
        {
            public int x { get; set; }
            public int y { get; set; }
        }

        public class BoundingPoly
        {
            public List<Vertices> vertices { get; set; }
        }

        public class Item
        {
            public string locale { get; set; }
            public string description { get; set; }
            public BoundingPoly boundingPoly { get; set; }
        }

        public class Root
        {
            public List<Item> items { get; set; }
        }
    }
}
