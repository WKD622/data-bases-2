using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.Entity;

namespace entity_linq
{
    public partial class Form2 : Form
    {
        ProdContext _context;
        public Form2()
        {
            InitializeComponent();
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            _context = new ProdContext();

            // Call the Load method to get the data for the given DbSet
            // from the database.
            // The data is materialized as entities. The entities are managed by
            // the DbContext instance.
            _context.Categories.Load();

            // Bind the categoryBindingSource.DataSource to
            // all the Unchanged, Modified and Added Category objects that
            // are currently tracked by the DbContext.
            // Note that we need to call ToBindingList() on the
            // ObservableCollection<TEntity> returned by
            // the DbSet.Local property to get the BindingList<T>
            // in order to facilitate two-way binding in WinForms.
            this.categoriesBindingSource.DataSource =
                _context.Categories.Local.ToBindingList();
            this.productsBindingSource.DataSource = 
                _context.Products.Local.ToBindingList();
        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (categoriesDataGridView.CurrentCell.ColumnIndex.Equals(1) && e.RowIndex != -1)
            {
                if (categoriesDataGridView.CurrentCell != null && categoriesDataGridView.CurrentCell.Value != null)
                    Console.WriteLine(categoriesDataGridView.CurrentCell.Value.ToString());        }
        }

            private void categoriesBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            this.Validate();
            foreach (var category in _context.Categories.Local.ToList())
            {
                if (category == null)
                {
                    _context.Categories.Remove(category);
                }
            }
            this._context.SaveChanges();
            this.categoriesDataGridView.Refresh();
            this.productsDataGridView.Refresh();
            this.categoriesBindingSource.EndEdit();
            this.tableAdapterManager.UpdateAll(this._entity_linq_ProdContextDataSet);
        }

        private void Form2_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the '_entity_linq_ProdContextDataSet1.Products' table. You can move, or remove it, as needed.
            this.productsTableAdapter.Fill(this._entity_linq_ProdContextDataSet1.Products);
            // TODO: This line of code loads data into the '_entity_linq_ProdContextDataSet.Categories' table. You can move, or remove it, as needed.
            this.categoriesTableAdapter.Fill(this._entity_linq_ProdContextDataSet.Categories);

        }
    }
}
