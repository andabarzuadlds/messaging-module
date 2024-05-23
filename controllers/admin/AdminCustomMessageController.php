<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

require '../vendor/autoload.php';

class AdminCustomMessageController extends ModuleAdminController
{
    public function __construct()
    {
        
        $this->bootstrap = true;
        parent::__construct();
    }
    

public function postProcess()
{   
    if (Tools::isSubmit('btnOrder_attached')) {
        $attach_order = Tools::getValue('order_attached');
        $idOrder = (int)Tools::getValue('id_order');
    
        $result = $this->module->insertOrderAttached($attach_order, $idOrder);
        if ($result['success']) {
            $adminLink = $this->context->link->getAdminLink('AdminOrders', true, ['id_order' => $idOrder, 'vieworder' => 1]) . '&message=successAttachment';
            Tools::redirectAdmin($adminLink);
        } else {
            // Manejar el error
            $errorLink = $this->context->link->getAdminLink('AdminOrders', true, ['id_order' => $idOrder, 'vieworder' => 1]) . '&message=' . urlencode($result['message']);
            Tools::redirectAdmin($errorLink);
        }
    }
    if (Tools::isSubmit('btnOrder_not_attached')) {
        $attach_order = Tools::getValue('order_attached');
        $idOrder = (int)Tools::getValue('id_order');
    
        $result = $this->module->removeOrderAttached($attach_order, $idOrder);
        if ($result['success']) {
            $adminLink = $this->context->link->getAdminLink('AdminOrders', true, ['id_order' => $idOrder, 'vieworder' => 1]) . '&message=successRemove';
            Tools::redirectAdmin($adminLink);
        } else {
            // Manejar el error
            $errorLink = $this->context->link->getAdminLink('AdminOrders', true, ['id_order' => $idOrder, 'vieworder' => 1]) . '&message=' . urlencode($result['message']);
            Tools::redirectAdmin($errorLink);
        }
    }

    
    if (Tools::isSubmit('btnPagado')) {
        $idOrder = (int)Tools::getValue('id_order');
        $order = new Order($idOrder);
        $orderId = $order->id;

        $data = array(
            'payment_status' => 1,
        );
        if (Db::getInstance()->update('orders', $data, 'id_order = '.(int)$orderId)) {
            $adminLink = $this->context->link->getAdminLink('AdminOrders', true, ['id_order' => $idOrder, 'vieworder' => 1]) . '&message=successPay';
            Tools::redirectAdmin($adminLink);
        } else {
            echo "Error al actualizar el estado";
        }
    }
    if (Tools::isSubmit('btnNoPagado')) {
        $idOrder = (int)Tools::getValue('id_order');
        $order = new Order($idOrder);
        $orderId = $order->id;

        $data = array(
            'payment_status' => 2,
        );
        if (Db::getInstance()->update('orders', $data, 'id_order = '.(int)$orderId)) {
            $adminLink = $this->context->link->getAdminLink('AdminOrders', true, ['id_order' => $idOrder, 'vieworder' => 1]) . '&message=paymentNot';
            Tools::redirectAdmin($adminLink);
        } else {
            echo "Error al actualizar el estado";
        }
    }    
    if (Tools::isSubmit('btnCredito')) {
        $idOrder = (int)Tools::getValue('id_order');
        $order = new Order($idOrder);
        $orderId = $order->id;

        $data = array(
            'payment_status' => 3,
        );
        if (Db::getInstance()->update('orders', $data, 'id_order = '.(int)$orderId)) {
            $adminLink = $this->context->link->getAdminLink('AdminOrders', true, ['id_order' => $idOrder, 'vieworder' => 1]) . '&message=successCredit';
            Tools::redirectAdmin($adminLink);
        } else {
            echo "Error al actualizar el estado";
        }
    }
            function enviarCorreo($destinatario, $nombreDestinatario, $area, $idOrder, $customer, $customMessage, $destinatarios) {
                try {

                    $mail = new PHPMailer(true);
                    $mail->isSMTP();
                    $mail->Host = 'smtp.gmail.com';
                    $mail->SMTPAuth = true;
                    $mail->Username = 'and.abarzua@dlds.cl';
                    $mail->Password = 'AQUI LA CONTRASEÑA DE SMTP';
                    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS; 
                    $mail->Port = 587;
            
                    $mail->setFrom('and.abarzua@dlds.cl', 'DLDS Distribuidores');
                    $mail->addAddress($destinatario, $nombreDestinatario);
                    $mail->isHTML(true);
                    $mail->Subject = 'Nuevo Mensaje para la orden ' . $idOrder;

                    $shop_name = "DLDS Distribuidores";
            
                    $bodyContent = '<!DOCTYPE html>
                    <html>
                    <head>
                    </head>
                    <body>
                    <h1 style="text-align: center;"><img src="https://dlds.cl/img/dlds-distribuidores-logo-1704289714.jpg" alt=""/></h1>
                    <p style="text-align: center;">Hola! Tienes un nuevo Mensaje de  en ' . $area . '</p>
                    <p style="text-align: center;">Cliente:</p>
                    <p style="text-align: center;">Numero de Orden: ' . $idOrder . '</p>
                    <p style="text-align: center;">Mensaje: ' . $customMessage . '</p>
                    <p style="text-align: center;">Destinatarios: ' . $destinatarios . '</p>
                    <hr />
                    <p style="text-align: center;"><span>&reg; ' . $shop_name . ' 2024</span></p>
                    </body>
                    </html>';
            
                    $mail->Body = $bodyContent;
                    $mail->AltBody = 'Este es el contenido en texto plano del mensaje para clientes de correo que no soportan HTML.';
                    
                    $mail->send();

                } catch (Exception $e) {
                    echo "Error al enviar mensaje: " . $mail->ErrorInfo;
                }
            }    
            if (Tools::isSubmit('submitCustomMessage')) {
                $customMessage = Tools::getValue('custom_message');
                $idOrder = (int)Tools::getValue('id_order');
                $idEmployee = (int)$this->context->employee->id;
                $employee = new Employee($idEmployee);
                $customer = new Customer(Tools::getValue('idcustomer'));
            
                if (!empty($customMessage) && $idOrder > 0 && $idEmployee > 0) {
                    $result = $this->module->insertCustomMessage($customMessage, $idOrder, $idEmployee);
                    
                    if ($_SERVER["REQUEST_METHOD"] == "POST" && $result) {
                        $senders = [
                            'Tecnologia' => ['email'       => 'Tecnologia@dlds.cl', 'name' => 'Tecnologia DLDS', 'label' => 'Área de Tecnología'],
                            'Ventas' => ['email'      => 'ventas@dlds.cl', 'name' => 'Ventas DLDS', 'label' => 'Área de Ventas'],
                            'Facturacion' => ['email'        => 'facturacion@dlds.cl', 'name' => 'Facturación DLDS', 'label' => 'Área de Facturación'],
                            'Semillas' => ['email'    => 'Semillas@dlds.cl', 'name' => 'Semillas DLDS', 'label' => 'Área de Semillas'],
                            'Marketing' => ['email'         => 'Marketing@dlds.cl', 'name' => 'Marketing DLDS', 'label' => 'Área de Marketing'],
                            'Abastecimiento' => ['email'       => 'Abastecimiento@dlds.cl', 'name' => 'Abastecimiento DLDS', 'label' => 'Área de Abastecimiento'],
                            'PostVenta' => ['email'     => 'Servicioalcliente@dlds.cl', 'name' => 'Servicio al Cliente DLDS', 'label' => 'Área de Servicio al Cliente'],
                            'NotaCredito' => ['email' => 'Mavendano@dlds.cl', 'name' => 'Nota de Credito DLDS', 'label' => 'Área de Nota de Credito'],
                        ];
            
                        if (isset($_POST['area'])) {
                            foreach ($senders as $key => $sender) {
                                if (isset($_POST['area'][$key]) && $_POST['area'][$key] === "Enviar") {
                                    // Asumiendo que $_POST['area'] ya es un array directamente con los valores
                                    $areas = $_POST['area'];
                                    
                                    $nombreDesignado = "";  // Texto que antecede a la lista de áreas
                                    $areasList = [];  // Array para almacenar solo los nombres de las áreas a enviar
                                    
                                    foreach ($areas as $key => $value) {
                                        if ($value === "Enviar") {
                                            $areasList[] = $key;  // Añadimos la clave al array de áreas a enviar
                                        }
                                    }
                                    $destinatarios = $nombreDesignado . implode(", ", $areasList);
                                    enviarCorreo($sender['email'], $sender['name'], $sender['label'], $idOrder, $customer, $customMessage, $destinatarios);
                                    $adminLink = $this->context->link->getAdminLink('AdminOrders', true, ['id_order' => $idOrder, 'vieworder' => 1]) . '&message=success';
                                    Tools::redirectAdmin($adminLink);
                                }
                        }
            
                    } else {
                        $this->errors[] = $this->l('Hubo un error al guardar el mensaje.');
                    }
                }
            }

}
}}
