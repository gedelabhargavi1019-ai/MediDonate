import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/donation_model.dart';
import '../models/request_model.dart';
import '../models/delivery_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('medidonate.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Create donations table
    await db.execute('''
      CREATE TABLE donations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicineName TEXT NOT NULL,
        category TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        expiryDate TEXT NOT NULL,
        description TEXT,
        donorName TEXT NOT NULL,
        donorEmail TEXT NOT NULL,
        donorPhone TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'Pending',
        createdAt TEXT NOT NULL
      )
    ''');

    // Create requests table
    await db.execute('''
      CREATE TABLE requests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicineName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        priority TEXT NOT NULL,
        additionalDetails TEXT,
        receiverName TEXT NOT NULL,
        receiverEmail TEXT NOT NULL,
        receiverPhone TEXT NOT NULL,
        receiverAddress TEXT NOT NULL,
        medicalCondition TEXT,
        status TEXT NOT NULL DEFAULT 'Pending',
        createdAt TEXT NOT NULL
      )
    ''');

    // Create deliveries table
    await db.execute('''
      CREATE TABLE deliveries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        requestId INTEGER NOT NULL,
        donationId INTEGER NOT NULL,
        recipientName TEXT NOT NULL,
        recipientPhone TEXT NOT NULL,
        deliveryAddress TEXT NOT NULL,
        deliveryDate TEXT NOT NULL,
        trackingNumber TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'Pending',
        createdAt TEXT NOT NULL,
        deliveredAt TEXT,
        FOREIGN KEY (requestId) REFERENCES requests (id),
        FOREIGN KEY (donationId) REFERENCES donations (id)
      )
    ''');
  }

  // ==================== DONATION OPERATIONS ====================

  Future<int> createDonation(DonationModel donation) async {
    final db = await instance.database;
    return await db.insert('donations', donation.toMap());
  }

  Future<DonationModel?> getDonation(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'donations',
      columns: [
        'id',
        'medicineName',
        'category',
        'quantity',
        'expiryDate',
        'description',
        'donorName',
        'donorEmail',
        'donorPhone',
        'status',
        'createdAt',
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DonationModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<DonationModel>> getAllDonations() async {
    final db = await instance.database;
    final result = await db.query('donations', orderBy: 'createdAt DESC');
    return result.map((map) => DonationModel.fromMap(map)).toList();
  }

  Future<List<DonationModel>> getDonationsByDonor(String donorEmail) async {
    final db = await instance.database;
    final result = await db.query(
      'donations',
      where: 'donorEmail = ?',
      whereArgs: [donorEmail],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => DonationModel.fromMap(map)).toList();
  }

  Future<int> updateDonation(DonationModel donation) async {
    final db = await instance.database;
    return db.update(
      'donations',
      donation.toMap(),
      where: 'id = ?',
      whereArgs: [donation.id],
    );
  }

  Future<int> deleteDonation(int id) async {
    final db = await instance.database;
    return await db.delete(
      'donations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getDonationCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM donations');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==================== REQUEST OPERATIONS ====================

  Future<int> createRequest(RequestModel request) async {
    final db = await instance.database;
    return await db.insert('requests', request.toMap());
  }

  Future<RequestModel?> getRequest(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'requests',
      columns: [
        'id',
        'medicineName',
        'quantity',
        'priority',
        'additionalDetails',
        'receiverName',
        'receiverEmail',
        'receiverPhone',
        'receiverAddress',
        'medicalCondition',
        'status',
        'createdAt',
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return RequestModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<RequestModel>> getAllRequests() async {
    final db = await instance.database;
    final result = await db.query('requests', orderBy: 'createdAt DESC');
    return result.map((map) => RequestModel.fromMap(map)).toList();
  }

  Future<List<RequestModel>> getRequestsByReceiver(String receiverEmail) async {
    final db = await instance.database;
    final result = await db.query(
      'requests',
      where: 'receiverEmail = ?',
      whereArgs: [receiverEmail],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => RequestModel.fromMap(map)).toList();
  }

  Future<List<RequestModel>> getRequestsByMedicineName(String medicineName) async {
    final db = await instance.database;
    final result = await db.query(
      'requests',
      where: 'medicineName LIKE ?',
      whereArgs: ['%$medicineName%'],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => RequestModel.fromMap(map)).toList();
  }

  Future<int> updateRequest(RequestModel request) async {
    final db = await instance.database;
    return db.update(
      'requests',
      request.toMap(),
      where: 'id = ?',
      whereArgs: [request.id],
    );
  }

  Future<int> deleteRequest(int id) async {
    final db = await instance.database;
    return await db.delete(
      'requests',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getRequestCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM requests');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==================== DELIVERY OPERATIONS ====================

  Future<int> createDelivery(DeliveryModel delivery) async {
    final db = await instance.database;
    return await db.insert('deliveries', delivery.toMap());
  }

  Future<DeliveryModel?> getDelivery(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'deliveries',
      columns: [
        'id',
        'requestId',
        'donationId',
        'recipientName',
        'recipientPhone',
        'deliveryAddress',
        'deliveryDate',
        'trackingNumber',
        'status',
        'createdAt',
        'deliveredAt',
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DeliveryModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<DeliveryModel>> getAllDeliveries() async {
    final db = await instance.database;
    final result = await db.query('deliveries', orderBy: 'createdAt DESC');
    return result.map((map) => DeliveryModel.fromMap(map)).toList();
  }

  Future<List<DeliveryModel>> getDeliveriesByRequest(int requestId) async {
    final db = await instance.database;
    final result = await db.query(
      'deliveries',
      where: 'requestId = ?',
      whereArgs: [requestId],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => DeliveryModel.fromMap(map)).toList();
  }

  Future<List<DeliveryModel>> getDeliveriesByDonation(int donationId) async {
    final db = await instance.database;
    final result = await db.query(
      'deliveries',
      where: 'donationId = ?',
      whereArgs: [donationId],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => DeliveryModel.fromMap(map)).toList();
  }

  Future<int> updateDelivery(DeliveryModel delivery) async {
    final db = await instance.database;
    return db.update(
      'deliveries',
      delivery.toMap(),
      where: 'id = ?',
      whereArgs: [delivery.id],
    );
  }

  Future<int> deleteDelivery(int id) async {
    final db = await instance.database;
    return await db.delete(
      'deliveries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getDeliveryCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM deliveries');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==================== UTILITY OPERATIONS ====================

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future clearAllData() async {
    final db = await instance.database;
    await db.delete('donations');
    await db.delete('requests');
    await db.delete('deliveries');
  }
}
