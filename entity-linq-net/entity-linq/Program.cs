using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Globalization;
using System.Data.SqlClient;
using System.Data.Common;

namespace entity_linq
{
    class Program
    {
        static void Main(string[] args)
        {
            using (var db = new ProdContext())
            {
                /*Console.WriteLine("Podaj nazwe kategorii: ");
                var name = Console.ReadLine();

                var category = new Category { Name = name };
                db.Categories.Add(category);
                db.SaveChanges();

                var query = from p in db.Categories
                            orderby p.Name descending
                            select p;
                foreach (var item in query)
                {
                    Console.WriteLine(item.Name);
                }*/
                //Console.WriteLine("Nazwy kategori za pomocą method syntax");
                var query2 = db.Categories.Select(p => p.Name);
                foreach (var item in query2)
                {
                    Console.WriteLine(item);
                }
                var product = new Product { Name = "alala", CategoryID = 1 };
                db.Products.Add(product);
                db.SaveChanges();

                var query3 = db.Categories.Join(
                    db.Products,
                    product => product.CategoryID,
                    category => category.CategoryID,
                    (product, category) => new
                    {
                        CategoryName = category.Name,
                        ProductName = product.Name
                    });
                foreach (var entry in query3)
                {
                    Console.WriteLine(entry.CategoryName + " - " + entry.ProductName);
                }

                var query4 = from c in db.Categories
                             join p in db.Products on c.CategoryID equals p.CategoryID
                             select new
                             {
                                 CategoryName = c.Name,
                                 ProductName = p.Name
                             };
                foreach(var entry in query4)
                {
                    Console.WriteLine(entry.CategoryName + " - " + entry.ProductName);
                }
                new Form2().ShowDialog();
                Console.ReadKey();
            }
        }
    }

    class Category
    {
        public int CategoryID { get; set; }
        public String Name { get; set; }
        List<Product> Products { get; set; }
        public String Description { get; set; }
    }

    class Product
    {
        public int ProductID { get; set; }
        public String Name { get; set; }
        public int UnitInStock { get; set; }
        public int CategoryID { get; set; }
        [Column(TypeName = "Money")]
        public decimal UnitPrice { get; set; }
    }

    class Customer
    {
        [Key]
        public String CompanyName { get; set; }
        public String Description { get; set; }
    }

    class ProdContext : DbContext
    {
        public DbSet<Product> Products { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<Customer> Customers { get; set; }
    }
}
