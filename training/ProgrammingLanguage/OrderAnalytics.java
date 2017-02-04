/**
 * 
 */
package com.sap.demo.app;

import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.SortedSet;
import java.util.TreeSet;

import com.sap.demo.bean.PurchaseOrder;
import com.sap.demo.db.CachedDB;

/**
 * @author root
 * 
 */
public class OrderAnalytics {
	private int performanceCycles = 1;

	public OrderAnalytics() {
		super();
	}

	public OrderAnalytics(int performanceCycles) {
		this();
		this.performanceCycles = performanceCycles;
	}

//	Java8 Streams & Lambda expressions demo	
//  @SuppressWarnings("unchecked")
	public SortedSet<Entry<Integer, Integer>> productAnalytics() {
		Map<Integer, Integer> productOrderQuantityMap = null;

		long milliSecondsStart = new Date().getTime();
		for (int i = 0; i < performanceCycles; i++) {
			productOrderQuantityMap = new HashMap<Integer, Integer>();
			for (PurchaseOrder purchaseOrder : CachedDB.getPurchaseOrderMap()
					.values()) {
				for (Entry<Integer, Integer> entry : purchaseOrder
						.getProductQuantityMap().entrySet()) {
					if (productOrderQuantityMap.containsKey(entry.getKey())) {
						productOrderQuantityMap.put(entry.getKey(),
								productOrderQuantityMap.get(entry.getKey())
										+ entry.getValue());
					} else {
						productOrderQuantityMap.put(entry.getKey(),
								entry.getValue());
					}
				}
			}
			
//			Java8 Streams & Lambda expressions demo			
//				productOrderQuantityMap = CachedDB
//						.getPurchaseOrderMap()
//						.values()
//						.stream()
//						.parallel()
//						.flatMap(
//								po -> po.getProductQuantityMap().entrySet()
//										.stream())
//						.collect(
//								Collectors.groupingBy(
//										t -> t.getKey(),
//										Collectors
//												.summingInt(t -> ((Entry<Integer, Integer>) t)
//														.getValue())));
		}

		long milliSecondsTotal = new Date().getTime() - milliSecondsStart;
		System.out.println("Total computing time: " + milliSecondsTotal);

		return integerEntriesSortedByValues(productOrderQuantityMap);
		
//		Java Demo: Sorting of Similar Collection
//		return entriesSortedByValues(productOrderQuantityMap);
	}

	public SortedSet<Entry<Integer, Double>> customerAnalytics() {
		Map<Integer, Double> customerRevenueMap = null;

		long milliSecondsStart = new Date().getTime();

		for (int i = 0; i < performanceCycles; i++) {
			customerRevenueMap = new HashMap<Integer, Double>();
			for (PurchaseOrder purchaseOrder : CachedDB.getPurchaseOrderMap()
					.values()) {
				if (customerRevenueMap.containsKey(purchaseOrder
						.getCustomerId())) {
					customerRevenueMap.put(purchaseOrder.getCustomerId(), Math
							.round((customerRevenueMap.get(purchaseOrder
									.getCustomerId()) + purchaseOrder
									.getTotalNetAmount()) * 100) / 100.00

					);
				} else {
					customerRevenueMap.put(purchaseOrder.getCustomerId(),
							purchaseOrder.getTotalNetAmount());
				}
			}

//			Java8 Streams & Lambda expressions demo
//			customerRevenueMap = CachedDB
//					.getPurchaseOrderMap()
//					.values()
//					.stream()
//					.parallel()
//					.collect(
//							Collectors.groupingBy(
//									po -> po.getCustomerId(),
//									Collectors
//											.summingDouble(po -> ((PurchaseOrder) po)
//													.getTotalNetAmount())));
		}
		long milliSecondsTotal = new Date().getTime() - milliSecondsStart;
		System.out.println("Total computing time: " + milliSecondsTotal);

		return doubleEntriesSortedByValues(customerRevenueMap);
		
//		Java Demo: Sorting of Similar Collection
//		return entriesSortedByValues(customerRevenueMap);
	}
	
	private static SortedSet<Map.Entry<Integer, Integer>> integerEntriesSortedByValues(
			Map<Integer, Integer> map) {
		SortedSet<Map.Entry<Integer, Integer>> sortedEntries = new TreeSet<Map.Entry<Integer, Integer>>(
				new Comparator<Map.Entry<Integer, Integer>>() {
					@Override
					public int compare(Map.Entry<Integer, Integer> a, Map.Entry<Integer, Integer> b) {
						int result = b.getValue().compareTo(a.getValue());

						if (result == 0) {
							result = 1;
						}
						return result;
					}
				});
		sortedEntries.addAll(map.entrySet());
		return sortedEntries;
	}
	
	private static SortedSet<Map.Entry<Integer, Double>> doubleEntriesSortedByValues(
			Map<Integer, Double> map) {
		SortedSet<Map.Entry<Integer, Double>> sortedEntries = new TreeSet<Map.Entry<Integer, Double>>(
				new Comparator<Map.Entry<Integer, Double>>() {
					@Override
					public int compare(Map.Entry<Integer, Double> a, Map.Entry<Integer, Double> b) {
						int result = b.getValue().compareTo(a.getValue());

						if (result == 0) {
							result = 1;
						}
						return result;
					}
				});
		sortedEntries.addAll(map.entrySet());
		return sortedEntries;
	}
	
//	Java Demo: Sorting of Similar Collection
//	private static <K, V extends Comparable<? super V>> SortedSet<Map.Entry<K, V>> entriesSortedByValues(
//			Map<K, V> map) {
//		SortedSet<Map.Entry<K, V>> sortedEntries = new TreeSet<Map.Entry<K, V>>(
//				new Comparator<Map.Entry<K, V>>() {
//					@Override
//					public int compare(Map.Entry<K, V> a, Map.Entry<K, V> b) {
//						int result = b.getValue().compareTo(a.getValue());
//
//						if (result == 0) {
//							result = 1;
//						}
//						return result;
//					}
//				});
//		sortedEntries.addAll(map.entrySet());
//		return sortedEntries;
//	}
}
