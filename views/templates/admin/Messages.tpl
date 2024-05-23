<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div class="container" style="background-color:#fff; margin-top:-15px; border-radius:5px;">
    <br>
    <center>
        <h3>Información del Pedido</h3>
    </center>
    <center>
        <div class="row" style="background-color:#fff; padding-top:20px;">
        {foreach $dashboard item=d}
        <div class="col-lg-8 mx-auto">
            <div class="info-container mb-4">
                <div class="info-item d-flex align-items-center">
                    <img width="60" height="60" src="https://nuevo.delightdistribuidores.cl/modules/messaging/img/truck.gif" alt="Transporte">
                    <span class=""><strong>Transporte: {$d.transporte}</strong></span>
                </div>
                <hr class="solid">
            </div>
            <div class="info-container mb-4">
                <div class="info-item d-flex align-items-center">
                    <img width="60" height="60" src="https://nuevo.delightdistribuidores.cl/modules/messaging/img/package.gif" alt="Peso">
                    <span class=""><strong>Peso del Pedido: {$d.peso} KG</strong></span>
                </div>
                <hr class="solid">
            </div>
            <div class="info-container mb-4">
                <div class="info-item d-flex align-items-center">
                    <img width="60" height="60" src="https://nuevo.delightdistribuidores.cl/modules/messaging/img/user.gif" alt="Vendedor Asignado">
                    <span class=""><strong>Vendedor Asignado: {$d.vendedor}</strong></span>
                </div>
                <hr class="solid">
            </div>
            <div class="info-container mb-4">
                <div class="info-item d-flex align-items-center">
                    <img width="60" height="60" src="https://nuevo.delightdistribuidores.cl/modules/messaging/img/social-care.gif" alt="Categoria Cliente">
                    <span class=""><strong>Categoria de Cliente: {$d.categoria}</strong></span>
                </div>
                <hr class="solid">
            </div>
        </div>
        {/foreach}
    </div></center>
    <center>
        <a class="btn btn-primary" target="_blank" href="{$link->getAdminLink('AdminPdf', true, [], ['submitAction' => 'generateTablePDF', 'id_order' => $order->id|intval])|escape:'html':'UTF-8'}">Ver Cotización</a>
    </center>
    <br>
</div>
<hr>
<div class="panel" style="background-color:white; border-radius:5px;">
        <main role="main" class="container bootdey.com" style="padding-top:5px;">
          <div class="d-flex align-items-center p-3 my-3 text-black rounded box-shadow" style="background-color:#fff; color:black;">
                <div class="text-black info-item d-flex align-items-center">
                    <img width="75" height="75" src="https://nuevo.delightdistribuidores.cl/modules/messaging/img/message.gif" alt="Transporte">
                    <span style="margin-left:65px;"><strong>Mensajeria de Pedido: #{$idOrder}</strong></span>
                </div>
          </div>

        <center>
            <h4>Selecciona el mensaje a cargar</h4>
                <select class="form-select " style="background-color:#fff; color:black; border-radius:5px; width:300px; height:30px;">
                    <!-- Opción predeterminada -->
                    <option>Selecciona un mensaje</option>
                
                    {foreach $allmessages item=m}
                        <option value="{$m.message|escape:'htmlattr'}">{$m.name}</option>
                    {/foreach}
                </select>
        </center>
          <div class="my-3 p-3 bg-white rounded box-shadow">
            <h5 class="border-bottom border-gray pb-2 mb-0">Ultimos Mensajes</h5>
            {foreach $messages item=m}
                <div class="media text-muted pt-3">
                  <img src="https://bootdey.com/img/Content/avatar/avatar7.png" alt="" class="mr-2 rounded" width="32" height="32">
                  <p class="media-body pb-3 mb-0 small lh-125 border-bottom border-gray">
                    <strong class="d-block text-gray-dark">Enviado por: {$m.firstname} {$m.lastname}</strong>
                    {$m.message}
                  </p>
                  <small>Hora: {$m.date_add}</small>
                </div>
            {/foreach}
            <center>
                <br>
                <button class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">Ver Todos los Mensajes</button>    
            </center>
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" >
                <div class="modal-center">
                    <div class="modal-dialog .modal-align-center">
                        <div class="modal-content">
                            <div class="modal-header">
                                <center>
                                    <h5 class="modal-title" id="myModalLabel" style="margin-left:130px;">Listado de Todos los Mensajes del Pedido</h5>
                                </center>
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Cerrar</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                {foreach $allmessagestoshow item=m}
                                    <div class="media text-muted pt-3">
                                      <img src="https://bootdey.com/img/Content/avatar/avatar7.png" alt="" class="mr-2 rounded" width="32" height="32">
                                      <p class="media-body pb-3 mb-0 small lh-125 border-bottom border-gray">
                                        <strong class="d-block text-gray-dark">Enviado por: {$m.firstname} {$m.lastname}</strong>
                                        {$m.message}
                                      </p>
                                      <small>Hora: {$m.date_add}</small>
                                    </div>
                                {/foreach}
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-primary" data-dismiss="modal">Salir</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
          </div>
        </main>
        <div>
            <div class="container">
                <div class="">
            		<div class="">
                        <div class="panel panel-default">
                            <div class="panel-body">
                            <form id="sendMessage" accept-charset="UTF-8" action="{$link->getAdminLink('AdminCustomMessage')|escape:'html'}" method="POST">
                                <center>
                                   <div class="container">
                                        <div class="row">
                                            <div class="col">
                                                <div class="bootstrap snippets bootdey">
                                                    <h5>Área de Tecnología</h5>
                                                    <div class="btn-group btn-toggle">
                                                        <label for="tecno_send_on" class="btn btn-sm btn-default ">Enviar</label><input type="radio" name="area[Tecnologia]" value="Enviar" autocomplete="off" id="tecno_send_on"> 
                                                        <label for="tecno_send_off" class="btn btn-sm btn-primary ">No Enviar</label><input type="radio" name="area[Tecnologia]" value="No Enviar" autocomplete="off" id="tecno_send_off" checked>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col">
                                                <div class="bootstrap snippets bootdey">
                                                    <h5>Vendedor Asignado</h5>
                                                    <div class="btn-group btn-toggle">
                                                        <label for="seller_send_on" class="btn btn-sm btn-default ">Enviar</label><input type="radio" name="area[Ventas]" value="Enviar" autocomplete="off" id="seller_send_on"> 
                                                        <label for="seller_send_off" class="btn btn-sm btn-primary ">No Enviar</label><input type="radio" name="area[Ventas]" value="No Enviar" autocomplete="off" id="seller_send_off" checked>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col">
                                                <div class="bootstrap snippets bootdey">
                                                    <h5>Área de Facturación</h5>
                                                    <div class="btn-group btn-toggle">
                                                        <label for="fact_send_on" class="btn btn-sm btn-default ">Enviar</label><input type="radio" name="area[Facturacion]" value="Enviar" autocomplete="off" id="fact_send_on"> 
                                                        <label for="fact_send_off" class="btn btn-sm btn-primary ">No Enviar</label><input type="radio" name="area[Facturacion]" value="No Enviar" autocomplete="off" id="fact_send_off" checked>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col">
                                                <div class="bootstrap snippets bootdey">
                                                    <h5>Área de Semillas</h5>
                                                    <div class="btn-group btn-toggle">
                                                        <label for="semillas_send_on" class="btn btn-sm btn-default ">Enviar</label><input type="radio" name="area[Semillas]" value="Enviar" autocomplete="off" id="semillas_send_on"> 
                                                        <label for="semillas_send_off" class="btn btn-sm btn-primary ">No Enviar</label><input type="radio" name="area[Semillas]" value="No Enviar" autocomplete="off" id="semillas_send_off" checked>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col">
                                                <div class="bootstrap snippets bootdey">
                                                    <h5>Área de Marketing</h5>
                                                    <div class="btn-group btn-toggle">
                                                        <label for="mkt_send_on" class="btn btn-sm btn-default ">Enviar</label><input type="radio" name="area[Marketing]" value="Enviar" autocomplete="off" id="mkt_send_on"> 
                                                        <label for="mkt_send_off" class="btn btn-sm btn-primary ">No Enviar</label><input type="radio" name="area[Marketing]" value="No Enviar" autocomplete="off" id="mkt_send_off" checked>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col">
                                                <div class="bootstrap snippets bootdey">
                                                    <h5>Área de Abastecimiento</h5>
                                                    <div class="btn-group btn-toggle">
                                                        <label for="abast_send_on" class="btn btn-sm btn-default ">Enviar</label><input type="radio" name="area[Abastecimiento]" value="Enviar" autocomplete="off" id="abast_send_on"> 
                                                        <label for="abast_send_off" class="btn btn-sm btn-primary ">No Enviar</label><input type="radio" name="area[Abastecimiento]" value="No Enviar" autocomplete="off" id="abast_send_off" checked>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col">
                                                <div class="bootstrap snippets bootdey">
                                                    <h5>PostVenta</h5>
                                                    <div class="btn-group btn-toggle">
                                                        <label for="psventa_send_on" class="btn btn-sm btn-default ">Enviar</label><input type="radio" name="area[PostVenta]" value="Enviar" autocomplete="off" id="psventa_send_on"> 
                                                        <label for="psventa_send_off" class="btn btn-sm btn-primary ">No Enviar</label><input type="radio" name="area[PostVenta]" value="No Enviar" autocomplete="off" id="psventa_send_off" checked>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col">
                                                <div class="bootstrap snippets bootdey">
                                                    <h5>Nota de Crédito</h5>
                                                    <div class="btn-group btn-toggle">
                                                        <label for="notacredito_send_on" class="btn btn-sm btn-default ">Enviar</label><input type="radio" name="area[NotaCredito]" value="Enviar" autocomplete="off" id="notacredito_send_on"> 
                                                        <label for="notacredito_send_off" class="btn btn-sm btn-primary ">No Enviar</label><input type="radio" name="area[NotaCredito]" value="No Enviar" autocomplete="off" id="notacredito_send_off" checked>
                                                    </div>
                                                </div>
                                            </div>
                                            <script>
                                                $(document).ready(function() {
                                                    $('.btn-toggle .btn').click(function() {
                                                        $(this).addClass('btn-primary').removeClass('btn-default');
                                                        $(this).siblings().removeClass('btn-primary').addClass('btn-default');
                                                    });
                                                });
                                            </script>
                                        </div>
                                    </div>
                                </center>
                                    <input type="hidden" name="id_order" value="{$idOrder|intval}">
                                    <input type="hidden" name="idcustomer" value="{$idcustomer|intval}">
                                    <textarea class="form-control counted" name="custom_message" placeholder="Escribe aquí tu Mensaje" rows="5" style="margin-bottom:10px;"></textarea>
                                    <button class="btn btn-info" type="submit" name="submitCustomMessage" style="margin-bottom:5px;" >Enviar Mensaje</button>
                            </form>
                            </div>
                        </div>
                    </div>
            	</div>
            </div>
        </div>
    </div>
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    const urlParams = new URLSearchParams(window.location.search);
                    const message = urlParams.get('message');
                     if (message === 'success') {
                    Swal.fire('Éxito', 'Mensaje enviado con éxito.', 'success');
                    }
                });
            </script>
            <script type="text/javascript">
                $(document).ready(function() {
                    $('.form-select').on('change', function() {
                        $('.form-control.counted').val($(this).val());
                    });
                });
            </script>
<style>
.info-item {
    display: flex;
    align-items: center;
    white-space: nowrap; /* Evita que el texto se envuelva */
    overflow: hidden; /* Oculta el texto que se extienda más allá del contenedor */
    text-overflow: ellipsis; /* Añade puntos suspensivos si el texto se desborda */
}

.info-item img {
    flex-shrink: 0; /* Previene que la imagen se reduzca */
    margin-right: 10px; /* Añade espacio entre la imagen y el texto */
}

.info-text {
     /* Permite que el texto ocupe el espacio disponible */
    overflow: hidden; /* Asegúrate de que el texto no desborde */
    text-overflow: ellipsis; /* Añade puntos suspensivos si el texto es demasiado largo */
}

.d-flex {
    display: flex; /* Esto activa flexbox para el contenedor */
    align-items: center; /* Alinea verticalmente los elementos hijos en el centro */
}

.d-flex img {
    margin-right: 10px; /* Añade un margen derecho a la imagen para separarla del texto */
}

.btn-default {
    background-color: #f8f9fa;
    color: #000;
}

.btn-primary {
    background-color: #21A6C1;
    color: #fff;
}
.modal-center {
    display:table;
    height: 100%;
    width: 100%;
}
.modal-align-center { 
    vertical-align: middle;
    
}
.modal-content {
    height:auto;
    margin: 0 auto;
    margin-top: -150px ;
    
}
.text-white-50 { color: rgba(255, 255, 255, .5); }
.bg-blue { background-color:#00b5ec; }
.border-bottom { border-bottom: 1px solid #e5e5e5; }
.box-shadow { box-shadow: 0 .25rem .75rem rgba(0, 0, 0, .05); }
</style>