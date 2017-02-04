package com.sap.demo.app;

import java.util.Map.Entry;
import java.util.Set;
import java.util.SortedSet;

import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.hsqldb.lib.StringUtil;

import com.sap.demo.bean.OrderAnalyticsResult;
import com.sap.demo.db.CachedDB;

@RemoteProxy
public class OrderAnalyticsController {
	private static final String PRODUCT_ANALYTICS_SERVICE_TYPE = "productAnalytics";
	private static final String CUSTOMER_ANALYTICS_SERVICE_TYPE = "customerAnalytics";
	
	private OrderAnalytics orderAnalytics = new OrderAnalytics();
	private int resultListSize;
	
	@RemoteMethod
	public OrderAnalyticsResult orderAnalyticsService(String serviceType, int newResultListSize) {
		resultListSize = newResultListSize;
		
		OrderAnalyticsResult result = null;
		
		if (!StringUtil.isEmpty(serviceType) && serviceType.equals(PRODUCT_ANALYTICS_SERVICE_TYPE)) {
			SortedSet<Entry<Integer, Integer>> productResultSet = orderAnalytics.productAnalytics();
			result = mapSetIntegerIntegerToResult(productResultSet);
//			Java Demo: Converting Collections
//			result = mapSetToResult(productResultSet);
		} else if (!StringUtil.isEmpty(serviceType) && serviceType.equals(CUSTOMER_ANALYTICS_SERVICE_TYPE)) {
			SortedSet<Entry<Integer, Double>> customerResultSet = orderAnalytics.customerAnalytics();
			result = mapSetIntegerDoubleToResult(customerResultSet);
//			Java Demo: Converting of Collections
//			result = mapSetToResult(productResultSet);
		}
		
		return result;
	}
	
	@RemoteMethod
	public void initializeCachedDB() {
		CachedDB.getCustomerMap();
		CachedDB.getProductMap();
		CachedDB.getPurchaseOrderMap();
	}
	
	private OrderAnalyticsResult mapSetIntegerIntegerToResult(Set<Entry<Integer, Integer>> set) {
		CollectionResultListTransformer<Entry<Integer, Integer>> transformer = 
				new CollectionResultListTransformer<Entry<Integer, Integer>>(resultListSize) {
			
			@Override
			protected OrderAnalyticsResult.Result transform(OrderAnalyticsResult result, Entry<Integer, Integer> entry) {
				return result.new Result(entry.getKey().toString(), entry.getValue().toString()); 
			}
		};
		
		return transformer.transform(set);
	}
	
	private OrderAnalyticsResult mapSetIntegerDoubleToResult(Set<Entry<Integer, Double>> set) {
		CollectionResultListTransformer<Entry<Integer, Double>> transformer = 
				new CollectionResultListTransformer<Entry<Integer, Double>>(resultListSize) {
			
			@Override
			protected OrderAnalyticsResult.Result transform(OrderAnalyticsResult result, Entry<Integer, Double> entry) {
				return result.new Result(entry.getKey().toString(), entry.getValue().toString()); 
			}
		};
		
		return transformer.transform(set);
	}
	
//	Java Demo: Converting of Collections
//	private <K, V> OrderAnalyticsResult mapSetToResult(Set<Entry<K, V>> set) {
//		CollectionResultListTransformer<Entry<K, V>> transformer = 
//				new CollectionResultListTransformer<Entry<K, V>>(resultListSize) {
//			
//			@Override
//			protected OrderAnalyticsResult.Result transform(OrderAnalyticsResult result, Entry<K, V> entry) {
//				return result.new Result(entry.getKey().toString(), entry.getValue().toString()); 
//			}
//		};
//		
//		return transformer.transform(set);
//	}
}
