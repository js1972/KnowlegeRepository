package com.sap.demo.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

import com.sap.demo.bean.Customer;
import com.sap.demo.bean.Product;
import com.sap.demo.bean.PurchaseOrder;

public class CachedDB {
	private static Map<Integer, Product> productMap = null;
	private static Map<Integer, Customer> customerMap = null;
	private static Map<Integer, PurchaseOrder> purchaseOrderMap = null;

	private CachedDB() {

	}

	public static Map<Integer, Product> getProductMap() {
		if (productMap == null) {
			initializeProductMap();
		}

		return productMap;
	}

	public static Map<Integer, PurchaseOrder> getPurchaseOrderMap() {
		if (purchaseOrderMap == null) {
			initializePurchaseOrderMap();
		}

		return purchaseOrderMap;
	}

	public static Map<Integer, Customer> getCustomerMap() {
		if (customerMap == null) {
			initializeCustomerMap();
		}

		return customerMap;
	}

	// Jerry 2015-11-13 9:11AM get PurchaseOrder from DB 
	private static void initializePurchaseOrderMap() {
		try {

			Connection dbConnection = getDBConnection();
			// fetch the Purchasue Order via DB connection
			getPurchaseOrders(dbConnection);
			System.out.println("Initialization of purchaseOrderMap finished.");
		} catch (SQLException e) {
			System.out.println("Initialization of purchaseOrderMap failed.");
			e.printStackTrace();
		}
	}

	private static void initializeProductMap() {
		try {
			Connection dbConnection = getDBConnection();
			getProducts(dbConnection);
			System.out.println("Initialization of productMap finished.");
		} catch (SQLException e) {
			System.out.println("Initialization of productMap failed.");
			e.printStackTrace();
		}
	}

	private static void initializeCustomerMap() {
		try {
			Connection dbConnection = getDBConnection();
			getCustomers(dbConnection);
			System.out.println("Initialization of customerMap finished.");
		} catch (SQLException e) {
			System.out.println("Initialization of customerMap failed.");
			e.printStackTrace();
		}
	}

	private static Connection getDBConnection() throws SQLException {
		Connection dbConnection = null;

		try {
			// Load the HSQL Database Engine JDBC driver
        	// hsqldb.jar should be in the class path or made part of the current jar
			Class.forName("org.hsqldb.jdbcDriver");
		} catch (Exception e) {
			System.err.println("ERROR: failed to load HSQLDB JDBC driver.");
			e.printStackTrace();
		}
		
		try {
			// connect to the database.   This will load the db files and start the
        	// database if it is not alread running.
        	// db_file_name_prefix is used to open or create files that hold the state
        	// of the db.
        	// It can contain directory names relative to the
        	// current working directory
        conn = DriverManager.getConnection("jdbc:hsqldb:"
                                           + db_file_name_prefix,    // filenames
                                           "sa",                     // username
                                           "");                      // password
			dbConnection = DriverManager.getConnection(
					"jdbc:hsqldb:file:/root/DemoDB/demoDB", "SA", "");
		} catch (SQLException e) {
			System.out.println("Could not get a DB connection.");
			throw e;
		}

		return dbConnection;
	}

	private static void getProducts(Connection dbConnection)
			throws SQLException {
		productMap = new HashMap<Integer, Product>();

		Statement statement = null;
		try {
			statement = dbConnection.createStatement();
			ResultSet resultSet = statement
					.executeQuery("select * from public.product");

			while (resultSet.next()) {
				productMap
						.put(resultSet.getInt(1),
								new Product(resultSet.getInt(1), resultSet
										.getString(2)));

			}
		} catch (SQLException e) {
			System.out.println("Could not get products from DB.");
			throw e;
		} finally {
			if (statement != null) {
				statement.close();
			}
			if (dbConnection != null) {
				try {
					dbConnection.close();
				} catch (SQLException e) {
					System.out.println("Could not close a DB connection.");
				}
			}
		}
	}

	private static void getPurchaseOrders(Connection dbConnection)
			throws SQLException {
		purchaseOrderMap = new HashMap<Integer, PurchaseOrder>();

		Statement statement = null;
		try {
			statement = dbConnection.createStatement();
			ResultSet resultSet = statement
					.executeQuery("select * from public.purchase_order");

			while (resultSet.next()) {
				purchaseOrderMap.put(
						resultSet.getInt(1),
						new PurchaseOrder(resultSet.getInt(1), resultSet
								.getInt(2), resultSet.getDate(4), resultSet.getDouble(3)));
			}

		} catch (SQLException e) {
			System.out.println("Could not get purchase orders from DB.");
			throw e;
		} finally {
			if (statement != null) {
				statement.close();
			}
		}

		getPurchaseOrderItems(dbConnection);
	}

	private static void getPurchaseOrderItems(Connection dbConnection)
			throws SQLException {
		Statement statement = null;
		try {
			statement = dbConnection.createStatement();
			ResultSet resultSet = statement
					.executeQuery("select * from public.purchase_order_item");

			while (resultSet.next()) {
				PurchaseOrder purchaseOrder = purchaseOrderMap.get(resultSet
						.getInt(3));

				purchaseOrder.addItem(resultSet.getInt(4), resultSet.getInt(5),
						resultSet.getDouble(6));
			}

		} catch (SQLException e) {
			System.out.println("Could not get purchase order items from DB.");
			throw e;
		} finally {
			if (statement != null) {
				statement.close();
			}
			
			if (dbConnection != null) {
				try {
					dbConnection.close();
				} catch (SQLException e) {
					System.out.println("Could not close a DB connection.");
				}
			}
		}
	}

	private static void getCustomers(Connection dbConnection)
			throws SQLException {
		customerMap = new HashMap<Integer, Customer>();

		Statement statement = null;
		try {
			statement = dbConnection.createStatement();
			ResultSet resultSet = statement
					.executeQuery("select * from public.customer;");

			while (resultSet.next()) {
				customerMap.put(
						resultSet.getInt(1),
						new Customer(resultSet.getInt(1), resultSet
								.getString(2), resultSet.getString(3)));
			}
		} catch (SQLException e) {
			System.out.println("Could not get customers from DB.");
			throw e;
		} finally {
			if (statement != null) {
				statement.close();
			}
			
			if (dbConnection != null) {
				try {
					dbConnection.close();
				} catch (SQLException e) {
					System.out.println("Could not close a DB connection.");
				}
			}
		}
	}
}
