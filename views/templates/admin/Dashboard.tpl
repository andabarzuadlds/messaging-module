
{debug}
<div class="container" style="background-color: #fff; padding: 20px; border-radius:5px; margin-top:-10px;">
    <div>
        <center>
            <h3>Dashboard del Pedido {$id_order}</h3>  
        </center>
    </div>
    <div class="row row-cols-1 row-cols-md-2 row-cols-xl-4">
        <script>
            document.addEventListener('DOMContentLoaded', function() {
              // Funci¨®n para actualizar el valor de descuento
              function updateDiscountValue() {
                // Obtener el texto desde el elemento con ID 'orderDiscountsTotal'
                var textValue = document.getElementById('totalPriceProducts').innerText;
            
                // Extraer solo los n¨²meros, el punto y el signo negativo si existe
                var numbersOnly = textValue.replace(/[^\d.-]/g, '');
            
                // Convertir el texto de n¨²meros a un n¨²mero flotante
                var discountNumber = parseFloat(numbersOnly);
            
                // Formatear el n¨²mero a pesos chilenos (CLP) sin mostrar el s¨ªmbolo de moneda
                var formattedDiscount = new Intl.NumberFormat('es-CL', {
                  style: 'currency',
                  currency: 'CLP',
                  currencyDisplay: 'code'
                }).format(discountNumber);
            
                // Ajustar el resultado para que el s¨ªmbolo de moneda aparezca al principio y agregar "CLP $"
                formattedDiscount = 'CLP $' + formattedDiscount.replace('CLP', '').trim();
            
                // Actualizar el elemento del DOM con el nuevo valor formateado
                document.getElementById('totalPriceProducts').innerText = formattedDiscount;
              }
            
              // Establecer un temporizador para ejecutar la actualizaci¨®n despu¨¦s de 0.5 milisegundos una vez que el DOM est¨¦ completamente cargado
                updateDiscountValue();
            });
        </script>
        <div class="col">
    		 <div class="card radius-10 border-start border-0 border-3 border-info">
    			<div class="card-body">
    				<div class="d-flex align-items-center">
    					<div>
    						<p class="mb-0 text-secondary">Total del Pedido (Lista) + IVA</p>
    						<h4 id="totalPriceProducts"class="my-1 text-info">{$totalPriceProducts * 1.19}</h4>
    						<p class="mb-0 font-13">+2.5% from last week</p>
    					</div>
    					<div class="widgets-icons-2 rounded-circle bg-gradient-scooter text-white ms-auto"><i class="fa fa-shopping-cart"></i>
    					</div>
    				</div>
    			</div>
    		 </div>
    	   </div>
    	<div class="col">
    	    <script>
    	        document.addEventListener('DOMContentLoaded', function() {
                  // Funci¨®n para actualizar el valor de descuento
                  function updateDiscountValue() {
                    // Obtener el texto desde el elemento con ID 'orderDiscountsTotal'
                    var textValue = document.getElementById('discountvalue').innerText;
                
                    // Extraer solo los n¨²meros, el punto y el signo negativo si existe
                    var numbersOnly = textValue.replace(/[^\d.-]/g, '');
                
                    // Convertir el texto de n¨²meros a un n¨²mero flotante
                    var discountNumber = parseFloat(numbersOnly);
                
                    // Formatear el n¨²mero a pesos chilenos (CLP) sin mostrar el s¨ªmbolo de moneda
                    var formattedDiscount = new Intl.NumberFormat('es-CL', {
                      style: 'currency',
                      currency: 'CLP',
                      currencyDisplay: 'code'
                    }).format(discountNumber);
                
                    // Ajustar el resultado para que el s¨ªmbolo de moneda aparezca al principio y agregar "CLP $"
                    formattedDiscount = 'CLP $' + formattedDiscount.replace('CLP', '').trim();
                
                    // Actualizar el elemento del DOM con el nuevo valor formateado
                    document.getElementById('discountvalue').innerText = formattedDiscount;
                  }
                
                  // Establecer un temporizador para ejecutar la actualizaci¨®n despu¨¦s de 0.5 milisegundos una vez que el DOM est¨¦ completamente cargado
                  setTimeout(updateDiscountValue, 0.5);
                });

    	    </script>
    		<div class="card radius-10 border-start border-0 border-3 border-danger">
    		   <div class="card-body">
    			   <div class="d-flex align-items-center">
    				   <div>
    					   <p class="mb-0 text-secondary">Descuento Total - IVA</p>
    					   {$totalDiscountsOrder = $order->total_discounts_tax_excl + $discountTotalProducts}
    					   <h4 id="discountvalue" class="my-1 text-danger">CLP ${$totalDiscountsOrder}</h4>
    					   <p class="mb-0 font-13">+5.4% from last week</p>
    				   </div>
    				   <div class="widgets-icons-2 rounded-circle bg-gradient-bloody text-white ms-auto"><i class="fa fa-dollar"></i>
    				   </div>
    			   </div>
    		   </div>
    		</div>
    	  </div>
    	<div class="col">
    		<div class="card radius-10 border-start border-0 border-3 border-success">
    		   <div class="card-body">
    			   <div class="d-flex align-items-center">
    				   <div>
    					   <p class="mb-0 text-secondary">Margen de ContribuciÃ³n</p>
    					   <h4 class="my-1 text-success">${number_format(round($totalGain, 2), 0, ',', '.')}</h4>
    					   <p class="mb-0 font-13">-4.5% from last week</p>
    				   </div>
    				   <div class="widgets-icons-2 rounded-circle bg-gradient-ohhappiness text-white ms-auto"><i class="fa fa-bar-chart"></i>
    				   </div>
    			   </div>
    		   </div>
    		</div>
    	  </div>
    	<div class="col">
    		<div class="card radius-10 border-start border-0 border-3 border-warning">
    		   <div class="card-body">
    			   <div class="d-flex align-items-center">
    				   <div>
    					   <p class="mb-0 text-secondary">Porcentaje Descuento Total</p>
    					   <h4 class="my-1 text-warning">{number_format(round($percentageGain, 2), 2, ',', '.')}%</h4>
    					   <p class="mb-0 font-13">+8.4% from last week</p>
    				   </div>
    				   <div class="widgets-icons-2 rounded-circle bg-gradient-blooker text-white ms-auto"><i class="fa fa-users"></i>
    				   </div>
    			   </div>
    		   </div>
    		</div>
    	  </div> 
        <div class="col">
    		 <div class="card radius-10 border-start border-0 border-3 border-info">
    			<div class="card-body">
    				<div class="d-flex align-items-center">
    					<div>
    						<p class="mb-0 text-secondary">Total con Descuento + IVA</p>
    						<h4 class="my-1 text-info">{foreach $TotalWithDiscounts item=t}{$t.total_con_descuentos}{/foreach}</h4>
    						<p class="mb-0 font-13">+2.5% from last week</p>
    					</div>
    					<div class="widgets-icons-2 rounded-circle bg-gradient-scooter text-white ms-auto"><i class="fa fa-shopping-cart"></i>
    					</div>
    				</div>
    			</div>
    		 </div>
    	   </div>
    	<div class="col">
    		<div class="card radius-10 border-start border-0 border-3 border-danger">
    		   <div class="card-body">
    			   <div class="d-flex align-items-center">
    				   <div>
    					   <p class="mb-0 text-secondary">Total con Descuento - IVA</p>
    					   <h4 class="my-1 text-danger">{foreach $TotalDiscountsNoIva item=t}{$t.total_con_descuentos_sin_impuestos}{/foreach}</h4>
    					   <p class="mb-0 font-13">+5.4% from last week</p>
    				   </div>
    				   <div class="widgets-icons-2 rounded-circle bg-gradient-bloody text-white ms-auto"><i class="fa fa-dollar"></i>
    				   </div>
    			   </div>
    		   </div>
    		</div>
    	  </div>
    	<div class="col">
    		<div class="card radius-10 border-start border-0 border-3 border-success">
    		   <div class="card-body">
    			   <div class="d-flex align-items-center">
    				   <div>
    					   <p class="mb-0 text-secondary">Porcentaje de ContribuciÃ³n</p>
    					   <h4 class="my-1 text-success">34.6%</h4>
    					   <p class="mb-0 font-13">-4.5% from last week</p>
    				   </div>
    				   <div class="widgets-icons-2 rounded-circle bg-gradient-ohhappiness text-white ms-auto"><i class="fa fa-bar-chart"></i>
    				   </div>
    			   </div>
    		   </div>
    		</div>
    	  </div>
    	<div class="col">
    		<div class="card radius-10 border-start border-0 border-3 border-warning">
    		   <div class="card-body">
    			   <div class="d-flex align-items-center">
    				   <div>
    					   <p class="mb-0 text-secondary">Cantidad de Productos</p>
    					   <h4 class="my-1 text-warning">{foreach $cant_productos item=p}{$p.cant_productos}{/foreach}</h4>
    					   <p class="mb-0 font-13">+8.4% from last week</p>
    				   </div>
    				   <div class="widgets-icons-2 rounded-circle bg-gradient-blooker text-white ms-auto"><i class="fa fa-users"></i>
    				   </div>
    			   </div>
    		   </div>
    		</div>
    	  </div> 
    
    </div>
    <div class="">
          <div class="">
                {assign var='query' value="SELECT payment_status from r3pa_orders WHERE id_order = '{$order->id}'"}
                {assign var='status_payment' value=Db::getInstance()->getRow($query)}
                {if $status_payment.payment_status == '1'}
                    <div class="alert alert-success" role="alert">
                      PEDIDO CON PAGO ASOCIADO (ENTREGAR)
                    </div>{/if}
                {if $status_payment.payment_status == '2'}
                    <div class="alert alert-danger" role="alert">
                      PEDIDO SIN PAGO ASOCIADO (NO ENTREGAR)
                    </div>{/if}
                {if $status_payment.payment_status == '3'}
                    <div class="alert alert-warning" role="alert">
                      PEDIDO CLIENTE CREDITO (ENTREGAR)
                    </div>{/if}
                
                {if $employee->id == 2 or $employee->id == 23 or $employee->id == 87}
                <div class="d-flex justify-content-between">
                    <form method="post" action="{$link->getAdminLink('AdminCustomMessage')|escape:'html'}" id="formPayment">
                        <input type="hidden" name="id_order" value="{$id_order|intval}">
                        <input type="hidden" name="idcustomer" value="{$idcustomer|intval}">
                        <button type="submit" class="btn btn-success" name="btnPagado" value="1">Pagado</button>
                        <button type="submit" class="btn btn-danger" name="btnNoPagado" value="2">No Pagado</button>
                        <button type="submit" class="btn btn-warning" name="btnCredito" value="3">Cliente Credito</button>

                    </form>
                </div>
                {else}
                {/if}
                
                
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    const urlParams = new URLSearchParams(window.location.search);
                    const message = urlParams.get('message');
                    if (message === 'successPay') {
                    Swal.fire('Exito', 'Pedido actualizado a Pagado con exito.', 'success');
                    }
                    if (message === 'paymentNot') {
                    Swal.fire('Exito', 'Pedido actualizado a No Pagado con exito.', 'success');
                    }
                    if (message === 'successCredit') {
                    Swal.fire('Exito', 'Pedido actualizado a Cliente Credito con exito.', 'success');
                    }
                });
            </script>
                </div>
                    </div>
</div>

<br>
<style>
hr.dashed {
    border-top: 2px dashed #999;
}

hr.dotted {
    border-top: 2px dotted #999;
}

hr.solid {
    border-top: 2px solid #999;
}


hr.hr-text {
  position: relative;
    border: none;
    height: 1px;
    background: #999;
}

hr.hr-text::before {
    content: attr(data-content);
    display: inline-block;
    background: #fff;
    font-weight: bold;
    font-size: 0.85rem;
    color: #999;
    border-radius: 30rem;
    padding: 0.2rem 2rem;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}



/*
*
* ==========================================
* FOR DEMO PURPOSES
* ==========================================
*
*/

.text-uppercase {
  letter-spacing: .1em;
}
.radius-10 {
    border-radius: 10px !important;
}

.border-info {
    border-left: 5px solid  #0dcaf0 !important;
}
.border-danger {
    border-left: 5px solid  #fd3550 !important;
}
.border-success {
    border-left: 5px solid  #15ca20 !important;
}
.border-warning {
    border-left: 5px solid  #ffc107 !important;
}


.card {
    position: relative;
    display: flex;
    flex-direction: column;
    min-width: 0;
    word-wrap: break-word;
    background-color: #fff;
    background-clip: border-box;
    border-radius: .25rem;
    margin-bottom: 1.5rem;

}
.bg-gradient-scooter {
    background: #17ead9;
    background: -webkit-linear-gradient( 
45deg
 , #17ead9, #6078ea)!important;
    background: linear-gradient( 
45deg
 , #17ead9, #6078ea)!important;
}
.widgets-icons-2 {
    width: 56px;
    height: 56px;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #ededed;
    font-size: 27px;
    border-radius: 10px;
}
.rounded-circle {
    border-radius: 50%!important;
}
.text-white {
    color: #fff!important;
}
.ms-auto {
    margin-left: auto!important;
}
.bg-gradient-bloody {
    background: #f54ea2;
    background: -webkit-linear-gradient( 
45deg
 , #f54ea2, #ff7676)!important;
    background: linear-gradient( 
45deg
 , #f54ea2, #ff7676)!important;
}

.bg-gradient-ohhappiness {
    background: #00b09b;
    background: -webkit-linear-gradient( 
45deg
 , #00b09b, #96c93d)!important;
    background: linear-gradient( 
45deg
 , #00b09b, #96c93d)!important;
}

.bg-gradient-blooker {
    background: #ffdf40;
    background: -webkit-linear-gradient( 
45deg
 , #ffdf40, #ff8359)!important;
    background: linear-gradient( 
45deg
 , #ffdf40, #ff8359)!important;
}
</style>