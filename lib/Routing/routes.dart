const rootRoute = '/home';

const overViewPageDisplayName = 'OverView';
const overViewPageRoute = '/overView';

const inventoryPageDisplayName = "Inventory";
const inventoryPageRoute = "/inventory";

const productsPageDisplayName = 'Products';
const productsPageRoute = '/products';

const userPageDisplayName = 'Users';
const userPageRoute = '/employee';

const barcodePageDisplayName = 'Bar Code';
const barcodePageroute = '/bar Code';

const authenticationPageDisplayName = 'Log Out';
const authenticationPageRoute = '/auth';

const dispatchPageDisplayName = 'Dispatch';
const dispatchPageRoute = '/dispatch';

const pendingWorkDisplayName = "Pending Task";
const PendingtaskRoute = '/pending';

const TrashDisplayName = "Trash";
const trashRoute = '/trash';

class MenuItem {
  final String name;
  final String route;

  MenuItem({required this.name, required this.route});
}

List<MenuItem> sideMenuItems = [
  MenuItem(name: overViewPageDisplayName, route: overViewPageRoute),
  MenuItem(name: inventoryPageDisplayName, route: inventoryPageRoute),
  MenuItem(name: productsPageDisplayName, route: productsPageRoute),
  MenuItem(name: userPageDisplayName, route: userPageRoute),
  MenuItem(name: barcodePageDisplayName, route: barcodePageroute),
  MenuItem(name: dispatchPageDisplayName, route: dispatchPageRoute),
  MenuItem(name: authenticationPageDisplayName, route: authenticationPageRoute),
];
