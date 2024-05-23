
<div class="container" style="background-color: white; border-radius:5px;">
    <br>
    <div class="notice notice-success">
        <strong>Valor Promedio de Pedidos: </strong>{foreach $avgValueOrders item=o}{$o.valor_promedio}{/foreach}
    </div>
    <div class="notice notice-success">
        <strong>Promedio de Pedidos Mensuales: </strong>{foreach $avgOrders item=o}{$o.average_orders_per_month}{/foreach}
    </div>
	<div class="row mt-5">
		<div class="col-md-12">
            <div class="title-header text-center">
            <h4>Ultimos 7 Pedidos Realizados</h4>
            </div>
        </div>
	</div>
    <div class="row col-md-offset-2 custyle" style="padding: 15px;">
    <table class="table table-striped custab">
    <thead>
        <tr>
            <th class="text-center">ID Pedido</th>
            <th class="text-center">Fecha</th>
            <th class="text-center">Estado</th>
            <th class="text-center">Transporte</th>
            <th class="text-center">Valor Pagado</th>
            <th class="text-center">Accion</th>
        </tr>
    </thead>
    {foreach from=$orders item=order}
            <tr>
                <td class="text-center">{$order.pedido|escape:'html'}</td>
                <td class="text-center">{$order.fecha|date_format:"%Y-%m-%d %H:%M:%S"|escape:'html'}</td>
                <td class="text-center">{$order.state|escape:'html'}</td>
                <td class="text-center">{$order.transportista|escape:'html'}</td>
                <td class="text-center">{$order.valor|escape:'html'}</td>
                <td class="text-center">
                    <a class='btn btn-info btn-xs' href="index.php?controller=AdminOrders&id_order={$order.pedido}&vieworder">
                        <span class="glyphicon glyphicon-edit"></span> Ver Pedido
                    </a>
                </td>
            </tr>
        {/foreach}
    </table>
    </div>
    <div class="">
        <i class="icon-truck" style=" padding-top:15px;  height:20px;"></i> Transporte más utilizado: <strong>{foreach $carrier item=c}{$c.transportista}{/foreach}</strong>
    </div>
</div>

<style>
    .title-header:before {
        border-top: 2px solid #25b9d7;
        content: "";
        left: 0;
        position: absolute;
        right: 0;
        top: 50%;
    }

    .title-header h4 {
        margin-top: -20px;
        background: #fff;
        color: #363636;
        display: inline-block;
        font-weight: 600;
        line-height: 40px;
        margin: 0;
        padding: 0 10px;
        position: relative;
        text-transform: uppercase;
        border: 2px solid #25b9d7;
    }
    .notice {
    padding: 15px;
    background-color: #fafafa;
    border-left: 6px solid #7f7f84;
    margin-bottom: 10px;
    -webkit-box-shadow: 0 5px 8px -6px rgba(0,0,0,.2);
       -moz-box-shadow: 0 5px 8px -6px rgba(0,0,0,.2);
            box-shadow: 0 5px 8px -6px rgba(0,0,0,.2);
    }
    .notice-sm {
        padding: 10px;
        font-size: 80%;
    }
    .notice-lg {
        padding: 35px;
        font-size: large;
    }
    .notice-success {
        border-color: #80D651;
    }
    .notice-success>strong {
        color: #80D651;
    }
</style>