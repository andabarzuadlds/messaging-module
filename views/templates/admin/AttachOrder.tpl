<section>
        <div class="card" style="border-radius: 5px;">
          <div class="card-body p-4">
            <div class="d-flex text-black">
              <div class="flex-shrink-0">
                <img src="https://nuevo.delightdistribuidores.cl/modules/messaging/img/file.gif"
                  alt="Generic placeholder image" class="img-fluid"
                  style="width: 100px; border-radius: 5px;" />
              </div>
              <div class="flex-grow-1 ms-3">
                <div class="rounded-3 p-2" style="background-color: #efefef; border-radius:5px;">
                    {assign var='query' value="SELECT orden_adjunta, valor_orden_ad from r3pa_orders WHERE id_order = '{$order->id}'"}
                    {assign var='status_adjunta' value=Db::getInstance()->getRow($query)}

                    {if $status_adjunta.orden_adjunta > 0}
                    <h4>Pedido adjuntado:<br><br>
                    <center><h2>ID: {$status_adjunta.orden_adjunta}</h2></center></h4>
                        <form id="attachOrder" accept-charset="UTF-8" action="{$link->getAdminLink('AdminCustomMessage')|escape:'html'}" method="POST">
                            <input type="hidden" name="id_order" value="{$idOrder|intval}">
                            <button type="submit" name="btnOrder_not_attached" data-mdb-button-init data-mdb-ripple-init class="btn btn-danger me-1 flex-grow-1 w-100">
                            Eliminar Pedido Adjunto
                            </button>
                        </form>
                    {else}
                        <div><h3 class="">Adjunta tu pedido aquí</h3></div>
                        <h4>Pedido sin adjuntar</h4>
                        <form id="attachOrder" accept-charset="UTF-8" action="{$link->getAdminLink('AdminCustomMessage')|escape:'html'}" method="POST">
                            <input type="hidden" name="id_order" value="{$idOrder|intval}">
                            <input class="form-control counted" name="order_attached" placeholder="Escribe aquí el ID del pedido a Adjuntar" style="margin-bottom:10px;"></input>
                            <button type="submit" name="btnOrder_attached" data-mdb-button-init data-mdb-ripple-init class="btn btn-outline-primary me-1 flex-grow-1 w-100">
                            Adjuntar Pedido
                            </button>
                        </form>
                    {/if}
                </div>
              </div>
            </div>
          </div>
        </div>
</section>
<script>
    window.onload = function() {
        var orderField = document.getElementById('valueOrder1');
        var orderInput = document.getElementById('valueOrder');
        if (orderField) {
            orderInput.disabled = true;
        }
    };
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const message = urlParams.get('message');
        if (message === 'successAttachment') {
        Swal.fire('Pedido Adjuntado', 'Pedido adjuntado con exito.', 'success');
        }
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const message = urlParams.get('message');
        if (message === 'successRemove') {
        Swal.fire('Pedido Adjunto Eliminado', 'Pedido desligado con exito.', 'success');
        }
    });
</script>
<script type="text/javascript">
    // Obtener el ID del empleado
    var employeeId = {$employee->id|json_encode};
    document.addEventListener('DOMContentLoaded', function() {
        // Deshabilitar Nota Privada para todos los empleados excepto los ID seleccionados
        var employeeId = {$employee->id|json_encode};
        var textarea = document.getElementById('private_note_note');
        var botones = document.getElementsByClassName('js-private-note-btn');
        var boton = botones[0];
        if (employeeId !== 2 && employeeId !== 71 && employeeId !== 58 && employeeId !== 13 && employeeId !== 4) {
            if (textarea) textarea.disabled = true;
            if (boton) boton.disabled = true;
        }
    });
</script>




