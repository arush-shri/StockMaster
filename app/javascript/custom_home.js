function search() {
    console.log("SAX")
    var searchTerm = document.getElementById("searchBar").value.toLowerCase();
    var products = document.getElementsByClassName("ProductName");
  
    for (var i = 0; i < products.length; i++) {
        var product = products[i];
        var productName = product.textContent.toLowerCase();
  
        if (productName.indexOf(searchTerm) !== -1) {
            product.parentElement.style.display = "table-row";
        } else {
            product.parentElement.style.display = "none";
        }
    }
  }