<script>
$(document).ready(function() {
    $('#modifyOrder').click(function() {
        // Oculta la tabla 'productsModified' y muestra la 'products'
        $('#productsModified').hide();
        $('#orderProductsTable').show();
        // Activa automáticamente el primer botón con la clase 'js-order-product-edit-btn'
        $('.js-order-product-edit-btn').first().trigger('click');
        
    });
});
</script>

<script>
$(document).ready(function() {
    $('#addProductBtn').click(function() {
        // Oculta la tabla 'productsModified' y muestra la 'products'
        $('#productsModified').hide();
        $('#orderProductsTable').show();
    });
});
</script>

<div class="container my-5" style="width:1100px; margin-top:0px !important; border-radius:5px;" id="productsModified">
  <div class="shadow-4 rounded-5 overflow-hidden">
    <table class="table align-middle mb-0 bg-white"> 
      <thead class="bg-light">
        <tr>
          <th>Producto</th>
          <th>Precio Lista</th>
          <th>% de Descuento</th>
          <th>Precio con Descuento</th>
          <th>Cantidad</th>
          <th>Total</th>
          <th>Margen</th>
          <th>Stock Disponible</th>
        </tr>
      </thead>
      <tbody>
        {foreach $ProductsFromOrder item=p}
            <tr>
          <td>
            <div class="d-flex align-items-center">
                {foreach $urlImage item=i}
                    {if $i.product_id == $p.product_id}
                        <img
                           src="{$i.image_url}"
                           class="rounded-circle"
                           alt=""
                           style="width: 45px; height: 45px"
                        />
                    {/if}
                 {/foreach}
              <div class="ms-3">
                <p class="fw-bold mb-1"><a href="{$link->getAdminLink('AdminProducts', true, ['id_product' => $p.product_id|intval, 'updateproduct' => '1'])|escape:'html':'UTF-8'}">{$p.product_name}</a></p>
                <p class="fw-bold mb-1"><a href="{$link->getAdminLink('AdminProducts', true, ['id_product' => $p.product_id|intval, 'updateproduct' => '1'])|escape:'html':'UTF-8'}">{$p.reference}</a></p>

              </div>
            </div>
          </td>
          <td>
            <p class=" mb-1"><center>${number_format($p.price, 0, ',', '.')}</center></p>
          </td>
            <td>
              <span class="fw-normal mb-1" ><center style="background-color:#70b580 !important; color:#fff; width:60px; border-radius:5px; margin-left:20px;">{round(((1-($p.product_price/$p.original_product_price))*100))}%</center></span>
          </td>
          <td>
              <p class=" mb-1"><center>${number_format($p.product_price, 0, ',', '.')}</center></p>
          </td>
            <td>
              <p class=" mb-1"><center>{$p.product_quantity}</center></p>
          </td>
            <td>
              <p class=" mb-1"><center>${number_format($p.total_price_tax_excl , 0, ',', '.')}</center></p>
          </td>
          <td class="Margen">
    	    {$totalCost = 0}
            {$totalPrice = 0}
            {$totalCost = $totalCost + round($p.original_wholesale_price, 2)}
            {$totalPrice = $totalPrice + round($p.price, 2)}
    	    {$cost = (round((round($p.price, 2) - round($p.original_wholesale_price, 2)) / round($p.price, 2), 2)) *100}
    	    {$totalGain = $totalPrice - $totalCost}
    	    {if $cost <=10}
    	        <center><span class="badge" style="background-color:red;">{$cost}%</span></center>
    	        
    	    {/if}
    	    {if $cost >=11 && $cost<=20}
    	        <center><span class="badge" style="background-color:#ff8000;">{$cost}%</span></center>
    	    {/if}
    	    {if $cost >=21 && $cost<=29}
    	        <center><span class="badge " style="background-color:yellow; color:#000000;">{$cost}%</span></center>
    	    {/if}
    
    	    {if $cost >=30}
    	        <center><span class="badge" style="background-color:green; color:white;">{$cost}%</span></center>
    	    {/if}
    	</td>
    	   <td>
              <p class=" mb-1"><center>{$p.current_stock}</center></p>
          </td>
        </tr>
        {/foreach}
      </tbody>
    </table>
  </div>
</div>
