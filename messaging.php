<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

class Messaging extends Module
{
    protected $config_form = false;

    public function __construct()
    {
        $this->name = 'messaging';
        $this->tab = 'administration';
        $this->version = '1.0.0';
        $this->author = 'Andrés Abarzúa';
        $this->need_instance = 0;
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('Prestashop Personalization');
        $this->description = $this->l('Con este modulo se modifican varios apartados para tener una personalizacion mas detallada.');

        $this->ps_versions_compliancy = array('min' => '1.6', 'max' => '8.0');
    }

    public function install()
    {
        Configuration::updateValue('MESSAGING_LIVE_MODE', false);
    
        $installSuccess = parent::install() &&
                          $this->registerHook('header') &&
                          $this->registerHook('displayAdminOrderTabLink') &&  
                          $this->registerHook('displayAdminOrderSide') &&
                          $this->registerHook('displayListOfProducts') &&
                          $this->registerHook('displayMoreButtons') &&
                          $this->registerHook('displayBeforeOrderActions') &&
                          $this->registerHook('displayAttachOrder') &&
                          $this->registerHook('displayBackOfficeHeader');
    
        return (bool)$installSuccess;
    }
    private function installTab($parentClassName, $className, $name)
    {
        $tab = new Tab();
        $tab->active = 1;
        $tab->class_name = $className;
        $tab->name = [];
        foreach (Language::getLanguages(true) as $lang) {
            $tab->name[$lang['id_lang']] = $name;
        }
        $tab->id_parent = (int)Tab::getIdFromClassName($parentClassName);
        $tab->module = $this->name;
        return $tab->add();
    }

    public function uninstall()
        {
            
        Configuration::deleteByName('MESSAGING_LIVE_MODE');

        return parent::uninstall();
    }
    public function getContent()
        {
        if (((bool)Tools::isSubmit('submitMessagingModule')) == true) {
            $this->postProcess();
        }

        $this->context->smarty->assign('module_dir', $this->_path);

        $output = $this->context->smarty->fetch($this->local_path.'views/templates/admin/configure.tpl');

        return $output;
    }
    public function postProcess()
        {
        if (Tools::isSubmit('submitMessage')) {
            $token = Tools::getValue('token');
            if (Tools::isSubmit('token') && $token === Tools::getToken(false)) {
                $message = Tools::getValue('message');
                if ($message) {
                    $this->saveMessage($message);
                    $this->confirmations[] = $this->l('Mensaje enviado correctamente.');
                } else {
                    $this->errors[] = $this->l('El mensaje no puede estar vacío.');
                }
            } else {
                $this->errors[] = $this->l('Token de seguridad inválido.');
            }
        }
    }
    public function hookDisplayBackOfficeHeader()
        {
        if (Tools::getValue('configure') == $this->name) {
            $this->context->controller->addJS($this->_path.'views/js/back.js');
            $this->context->controller->addCSS($this->_path.'views/css/back.css');
        }
    }
    public function hookDisplayMoreButtons()
        {
            return $this->display(__FILE__, 'views/templates/admin/Buttons.tpl');
        }
    public function hookDisplayAttachOrder()
        {
            $idOrder = (int)Tools::getValue('id_order');
            $order = new Order($idOrder);
            
            $this->context->smarty->assign('idOrder', $idOrder);
            
            return $this->display(__FILE__, 'views/templates/admin/AttachOrder.tpl');
        }

    public function insertOrderAttached($attach_order, $idOrder)
    {
        $data = array(
            'orden_adjunta' => $attach_order,
            'valor_orden_ad' => 1,
        );
    
        if (Db::getInstance()->update('orders', $data, 'id_order = ' . (int)$idOrder)) {
            $sql = new DbQuery();
            $sql->select('valor_orden_ad, orden_adjunta');
            $sql->from('orders');
            $sql->where('id_order = '.(int)$idOrder);
            
            $results = Db::getInstance()->executeS($sql);
            
            // Asignar datos a la plantilla
            $this->context->smarty->assign('orden_adjunta_value', $results);
                    return [
                'success' => true,
                'data' => $results
            ];
            return $this->display(__FILE__, 'views/templates/admin/AttachOrder.tpl');
            
            // Devolver el estado y los resultados para un manejo adicional
    
        } else {
            return [
                'success' => false,
                'message' => 'Error al actualizar el pedido.'
            ];
        }
    }
    public function removeOrderAttached($attach_order, $idOrder)
    {
        $data = array(
            'orden_adjunta' => 0,
            'valor_orden_ad' => 0,
        );
    
        if (Db::getInstance()->update('orders', $data, 'id_order = ' . (int)$idOrder)) {
            $sql = new DbQuery();
            $sql->select('valor_orden_ad, orden_adjunta');
            $sql->from('orders');
            $sql->where('id_order = '.(int)$idOrder);
            
            $results = Db::getInstance()->executeS($sql);
            
            return [
                'success' => true,
                'data' => $results
            ];
            
        } else {
            return [
                'success' => false,
                'message' => 'Error al actualizar el pedido.'
            ];
        }
        
    }
    public function hookDisplayListOfProducts()
        {
            $idOrder = (int)Tools::getValue('id_order');
            $order = new Order($idOrder);
            if (Validate::isLoadedObject($order)) {
                $idCustomer = $order->id_customer; 
                
                $query = new DbQuery();
                $query->select('od.product_id, i.id_image, CONCAT(
                    "http://www.dlds.cl/img/p/",
                    SUBSTRING(REPLACE(i.id_image, "", "/"), 1, 1), "/",
                    SUBSTRING(REPLACE(i.id_image, "", "/"), 2, 1), "/",
                    SUBSTRING(REPLACE(i.id_image, "", "/"), 3, 1), "/",
                    SUBSTRING(REPLACE(i.id_image, "", "/"), 4, 1), "/",
                    i.id_image, ".jpg"
                ) AS image_url');
                $query->from('orders', 'o');
                $query->innerJoin('order_detail', 'od', 'o.id_order = od.id_order');
                $query->innerJoin('image', 'i', 'i.id_product = od.product_id');
                $query->where('o.id_customer = '.(int)$idCustomer);
                $query->where('o.id_order = '.(int)$idOrder); 
                $query->where('i.cover = 1');
                
                $results = Db::getInstance()->executeS($query);
                
                $ProductsFromOrder = $this->getProductsFromOrder($idOrder);
                $adminOrderUrl = $this->context->link->getAdminLink('AdminOrders', true, ['id_order' => $idOrder, 'vieworder' => 1]);
                
                $this->context->smarty->assign('adminOrderUrl', $adminOrderUrl);
                $this->context->smarty->assign('ProductsFromOrder', $ProductsFromOrder);
                $this->context->smarty->assign('urlImage', $results);
                
                return $this->display(__FILE__, 'views/templates/admin/ListProducts.tpl');
            }
        }
        
    public function hookDisplayAdminOrderTabLink()
        {
        $idOrder = (int)Tools::getValue('id_order');
        
        
        $order = new Order($idOrder);
        if (Validate::isLoadedObject($order)) {
            $idCustomer = $order->id_customer; 
            
            $sql = new DbQuery();
            $sql->select('o.id_order AS `pedido`, o.date_add AS `fecha`, osl.name AS `state`, c.name AS `transportista`, CONCAT("CLP $", FORMAT(o.total_paid_tax_incl, 0)) AS `valor`');
            $sql->from('orders', 'o');
            $sql->leftJoin('order_state_lang', 'osl', 'o.current_state = osl.id_order_state');
            $sql->leftJoin('carrier', 'c', 'o.id_carrier = c.id_carrier');
            $sql->where('o.id_customer = '.(int)$idCustomer);
            $sql->groupBy('o.id_order');
            $sql->orderBy('o.date_add DESC');
            $sql->limit(7);
            
            $results = Db::getInstance()->executeS($sql);
            
            
            $mostUsedCarrier = $this->getTheMostUsedCarrier($idCustomer);
            $avgOrders = $this->getAverageOrdersMonthly($idCustomer);
            $avgValueOrders = $this->getAverageValueOrders($idCustomer);
            
            
            $this->context->smarty->assign('orders', $results);
            $this->context->smarty->assign('carrier', $mostUsedCarrier);
            $this->context->smarty->assign('avgOrders', $avgOrders);
            $this->context->smarty->assign('avgValueOrders', $avgValueOrders);

            return $this->display(__FILE__, 'views/templates/admin/LastOrders.tpl');
        }

    }
    public function hookDisplayBeforeOrderActions()
        {
        $idOrder = (int)Tools::getValue('id_order');
        
        $order = new Order($idOrder);
        if (Validate::isLoadedObject($order)) {
            $idCustomer = $order->id_customer;
            $customer = new Customer($idCustomer);
            
            $sql = new DbQuery();
            
            $sql->select('count(product_id) AS `cant_productos`');
            $sql->from('order_detail');
            $sql->where('id_order = '.(int)$idOrder);
            $sql->limit(1);
            $results = Db::getInstance()->executeS($sql);

            $query = new DbQuery();
            
            $query->select('ROUND(SUM(od.`product_weight` * od.`product_quantity`) / 1000, 2) AS peso');
            $query->select('c.`name` AS transporte');
            $query->select('grl.`name` AS categoria');
            $query->select('cu.`website` AS vendedor');

            $query->from('orders', 'o');
            $query->innerJoin('order_detail', 'od', 'o.`id_order` = od.`id_order`');
            $query->innerJoin('carrier', 'c', 'o.`id_carrier` = c.`id_carrier`');
            $query->innerJoin('customer', 'cu', 'o.`id_customer` = cu.`id_customer`');
            $query->innerJoin('group_lang', 'grl', 'cu.`id_default_group` = grl.`id_group`');
            $query->where('o.id_order = '.(int)$idOrder);
            $query->where('grl.`id_lang` = 2');
            $query->groupBy('o.`id_order`');
            
            $result = Db::getInstance()->executeS($query);

            
            $TotalOrderNoDiscounts = $this->getTotalOrderNoDiscounts($idOrder);
            $TotalOrderWithDiscounts = $this->getTotalOrderWithDiscounts($idOrder);
            $TotalDiscounts = $this->getTotalDiscounts($idOrder);
            $TotalOrderWithDiscountsNoIva = $this->getTotalOrderWithDiscountsNoIva($idOrder);
            $ProductsFromOrder = $this->getProductsFromOrder($idOrder);
             
            $this->context->smarty->assign('dashboard', $result);
            $this->context->smarty->assign('cant_productos', $results);
            $this->context->smarty->assign('id_order', $idOrder);
            $this->context->smarty->assign('order', $order);
            $this->context->smarty->assign('customer', $customer);
            $this->context->smarty->assign('TotalNoDiscounts', $TotalOrderNoDiscounts);
            $this->context->smarty->assign('TotalWithDiscounts', $TotalOrderWithDiscounts);
            $this->context->smarty->assign('TotalDiscounts', $TotalDiscounts);
            $this->context->smarty->assign('TotalDiscountsNoIva', $TotalOrderWithDiscountsNoIva);
            $this->context->smarty->assign('ProductsFromOrder', $ProductsFromOrder);


            return $this->display(__FILE__, 'views/templates/admin/Dashboard.tpl');
        }

    }
    public function hookDisplayAdminOrderSide($params)
    {
        
        $idOrder = (int)Tools::getValue('id_order');
        if (Tools::isSubmit('submitCustomMessage')) {
            $customMessage = trim(Tools::getValue('custom_message'));
            PrestaShopLogger::addLog('Mensaje recibido: ' . $customMessage, 1);
            if (!empty($customMessage) && Validate::isLoadedObject(new Order($idOrder))) {
                if ($this->insertCustomMessage(pSQL($customMessage), $idOrder)) {
                    Tools::redirectAdmin(self::$currentIndex.'&id_order='.$idOrder.'&conf=4&token='.Tools::getAdminTokenLite('AdminOrders'));
                } else {
                    $this->context->controller->errors[] = $this->l('No se pudo guardar el mensaje.');
                }
            } else {
                $this->context->controller->errors[] = $this->l('El mensaje está vacío o la orden no es válida.');
            }
        }
        $order = new Order($idOrder);
        if (Validate::isLoadedObject($order)) {
            
            $sql = new DbQuery();
            $sql->select('c.message, e.firstname, e.lastname, c.date_add');
            $sql->from('custom_message', 'c');
            $sql->innerJoin('employee', 'e', 'e.id_employee = c.id_employee');
            $sql->where('c.id_order = '.(int)$idOrder);
            $sql->orderBy('c.date_add DESC');
            $sql->limit(5);
            
            $results = Db::getInstance()->executeS($sql);
            $id_customer = $order->id_customer;
            $gettAllCustomMessages = $this->getAllCustomMessages();
            $gettAllMessages = $this->getAllMessages();
            
            $this->context->smarty->assign('messages', $results);
            $this->context->smarty->assign('allmessagestoshow', $gettAllMessages);
            $this->context->smarty->assign('idcustomer', $id_customer);
            $this->context->smarty->assign('allmessages', $gettAllCustomMessages);
            $this->context->smarty->assign(['idOrder' => $idOrder]);
            return $this->display(__FILE__, 'views/templates/admin/Messages.tpl');
        }
    }
        public function getAllCustomMessages()
        {
            $idOrder = (int)Tools::getValue('id_order');
            $order = new Order($idOrder);
                if (Validate::isLoadedObject($order)) {
                    
                    $sql = new DbQuery();
                    $sql->select('b.name, b.message');
                    $sql->from('order_message', 'a');
                    $sql->innerJoin('order_message_lang', 'b', 'b.`id_order_message` = a.`id_order_message`');
                    $sql->where('b.id_lang = 2');
                    $sql->orderBy('a.id_order_message ASC');
                    $sql->limit(7);
                    
                    $results = Db::getInstance()->executeS($sql);
                    return $results;
            }

    }
        public function getAllMessages()
        {
            $idOrder = (int)Tools::getValue('id_order');
            $order = new Order($idOrder);
                if (Validate::isLoadedObject($order)) {
                    
                $sql = new DbQuery();
                $sql->select('c.message, e.firstname, e.lastname, c.date_add');
                $sql->from('custom_message', 'c');
                $sql->innerJoin('employee', 'e', 'e.id_employee = c.id_employee');
                $sql->where('c.id_order = '.(int)$idOrder);
                $sql->orderBy('c.date_add DESC');
                    
                    $results = Db::getInstance()->executeS($sql);
                    return $results;
            }

    }
    public function insertCustomMessage($message, $idOrder, $idEmployee)
    {
        $dateAdd = date('Y-m-d H:i:s');
        $sql = 'INSERT INTO `' . _DB_PREFIX_ . 'custom_message` (`message`, `date_add`, `id_order`, `id_employee`) VALUES ("' . pSQL($message) . '", "' . pSQL($dateAdd) . '", ' . (int)$idOrder . ', ' . (int)$idEmployee . ')';
        return Db::getInstance()->execute($sql);
    }

    public function getTheMostUsedCarrier()
        {
            $idOrder = (int)Tools::getValue('id_order');
            $order = new Order($idOrder);
            if (Validate::isLoadedObject($order)) {
                $idCustomer = $order->id_customer;
                
                $sql = new DbQuery();
                $sql->select('c.name AS `transportista`, COUNT(o.id_order) AS `numero_de_veces`');
                $sql->from('orders', 'o');
                $sql->innerJoin('carrier', 'c', 'o.id_carrier = c.id_carrier');
                $sql->where('o.id_customer = '.(int)$idCustomer);
                $sql->groupBy('o.id_carrier, c.name');
                $sql->orderBy('COUNT(o.id_order) DESC');
                $sql->limit(1);
    
                $results = Db::getInstance()->executeS($sql);
                
                return $results;
    
            }
        }
    public function getAverageOrdersMonthly()
        {
            $idOrder = (int)Tools::getValue('id_order');
            
            $order = new Order($idOrder);
            if (Validate::isLoadedObject($order)) {
                $idCustomer = $order->id_customer;

                $query = new DbQuery();
                $query->select('o.id_customer, ROUND(COUNT(o.id_order) / (DATEDIFF(CURDATE(), MIN(o.date_add)) / 30.4375), 0) AS average_orders_per_month');
                $query->from('orders', 'o');
                $query->where('o.id_customer = '.(int)$idCustomer);
                $query->groupBy('o.id_customer');
                
                $results = Db::getInstance()->executeS($query);

                return $results;
    
            }
        }
    public function getAverageValueOrders()
        {
            $idOrder = (int)Tools::getValue('id_order');
            
            $order = new Order($idOrder);
            if (Validate::isLoadedObject($order)) {
                $idCustomer = $order->id_customer;

                $query = new DbQuery();
                $query->select("CONCAT('CLP $', FORMAT(AVG(o.total_paid_tax_incl), 0)) AS 'valor_promedio'");
                $query->from('orders', 'o');
                $query->where('o.id_customer = '.(int)$idCustomer);

                $results = Db::getInstance()->executeS($query);
                
                return $results;   
            }
        }
    public function getTotalOrderNoDiscounts()
        {
            $idOrder = (int)Tools::getValue('id_order');
            $order = new Order($idOrder);
            if (Validate::isLoadedObject($order)) {
                $idCustomer = $order->id_customer;
                
                $query = new DbQuery();
                $query->select("CONCAT('CLP $', FORMAT((o.`total_paid_tax_incl` + o.`total_shipping`), 0)) AS 'total_sin_descuentos'");
                $query->from('orders', 'o');
                $query->where('o.`id_order` = '.(int)$idOrder);

                $results = Db::getInstance()->executeS($query);
    
                return $results;
    
            }
        }
    public function getTotalOrderWithDiscounts()
        {
            $idOrder = (int)Tools::getValue('id_order');
            
            $order = new Order($idOrder);
            if (Validate::isLoadedObject($order)) {
                $idCustomer = $order->id_customer;

                $query = new DbQuery();
                $query->select("CONCAT('CLP $', FORMAT(o.`total_paid_tax_incl`, 0)) AS 'total_con_descuentos'");
                $query->from('orders', 'o');
                $query->where('o.`id_order` = '.(int)$idOrder);
                
                $results = Db::getInstance()->executeS($query);

                return $results;
    
            }
        }
    public function getTotalDiscounts()
        {
            $idOrder = (int)Tools::getValue('id_order');
            $order = new Order($idOrder);
            if (Validate::isLoadedObject($order)) {
                $idCustomer = $order->id_customer;
                
                $query = new DbQuery();
                $query->select("CONCAT('CLP $', FORMAT((o.`total_products` + o.`total_shipping`) - o.`total_paid_tax_incl`, 0)) AS 'descuento_aplicado'");
                $query->from('orders', 'o');
                $query->where('o.`id_order` = '.(int)$idOrder);

                $results = Db::getInstance()->executeS($query);

                return $results;
    
            }
        }
    public function getTotalOrderWithDiscountsNoIva()
        {
            $idOrder = (int)Tools::getValue('id_order');
            
            $order = new Order($idOrder);
            if (Validate::isLoadedObject($order)) {
                $idCustomer = $order->id_customer;

                $query = new DbQuery();
                $query->select("CONCAT('CLP $', FORMAT(o.`total_paid_tax_excl`, 0)) AS 'total_con_descuentos_sin_impuestos'");
                $query->from('orders', 'o');
                $query->where('o.`id_order` = '.(int)$idOrder);

                $results = Db::getInstance()->executeS($query);
                
                return $results;
    
            }
        }
    public function getProductsFromOrder($orderId)
        {
            $order = new Order((int)$orderId);
        
            if (Validate::isLoadedObject($order)) {
                $products = $order->getProducts();
                
                return $products;
            }
        
            return [];
        }
    public function hookHeader()
        {
        $this->context->controller->addJS($this->_path.'/views/js/front.js');
        $this->context->controller->addCSS($this->_path.'/views/css/front.css');
    }
}
