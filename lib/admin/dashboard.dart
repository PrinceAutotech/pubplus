import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:image_network/image_network.dart';
import 'package:responsive_table/responsive_table.dart';
import '../../service/save/save.dart';
import '../view/add_campaign/add_campaign_page.dart';
import '../view/startup/login_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DataPageState();
}

class _DataPageState extends State<Dashboard> {
  late List<DatatableHeader> _headers;
  final List<int> _perPages = [10, 20, 50, 100];
  int _total = 100;
  int? _currentPerPage = 10;
  List<bool>? _expanded;
  String? _searchKey = 'articleName';
  final Save _save = Save();
  int _currentPage = 1;
  bool _isSearch = false;
  final List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selectedIds = [];

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  final bool _showSelect = true;

  User? currentUser = FirebaseAuth.instance.currentUser;

  List<Map<String, dynamic>>? fetchedData;
  Map<dynamic, dynamic>? data;
  List<Map<String, dynamic>> data1 = [];

  Future<List<Map<String, dynamic>>> _generateData() async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    final snapshot = await database
        .ref('Users')
        .child(currentUser!.uid)
        .child('Campaign')
        .get();
    if (snapshot.exists) {
      if (kDebugMode) {
        print(snapshot.value);
      }
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        data1.add(values);
      });
      List map = data1;
      fetchedData = List<Map<String, dynamic>>.from(map.map((data) => data));
      // fetchedData!.addAll(data1 as Iterable<Map<String, dynamic>>);
    } else {
      if (kDebugMode) {
        print('No data available.');
      }
      fetchedData = [];
    }
    return fetchedData!;
  }

  void _initializeData([bool refresh = false]) {
    _mockPullData(refresh);
  }

  Future<void> _mockPullData(bool refresh) async {
    _expanded = List.generate(_currentPerPage!, (index) => false);
    setState(() => _isLoading = true);
    var items = refresh ? await _generateData() : fetchedData!;
    _sourceOriginal
      ..clear()
      ..addAll(items);
    _sourceFiltered = _sourceOriginal;
    _total = _sourceFiltered.length;
    _source = _sourceFiltered
        .getRange(0, _total < _currentPerPage! ? _total : _currentPerPage!)
        .toList();
    setState(() => _isLoading = false);
  }

  Future<void> _resetData({int start = 0}) async {
    setState(() => _isLoading = true);
    int expandedLen =
        _total - start < _currentPerPage! ? _total - start : _currentPerPage!;
    await Future.delayed(const Duration(seconds: 0));
    _expanded = List.generate(expandedLen, (index) => false);
    _source.clear();
    _source = _sourceFiltered.getRange(start, start + expandedLen).toList();
    setState(() => _isLoading = false);
  }

  void _filterData(value) {
    setState(() => _isLoading = true);
    try {
      if (value == '' || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey!]
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()))
            .toList();
      }
      _total = _sourceFiltered.length;
      int rangeTop = _total < _currentPerPage! ? _total : _currentPerPage!;
      _expanded = List.generate(rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, rangeTop).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    /// set headers
    _headers = [
      DatatableHeader(
        text: 'Image',
        value: 'imageFile',
        show: true,
        sortable: false,
        flex: 1,
        textAlign: TextAlign.center,
        sourceBuilder: (value, row) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ImageNetwork(
            image: value,
            height: 180,
            width: 180,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_outlined),
                        iconSize: 20,
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ImageNetwork(
                        image: value,
                        height: 500,
                        width: 500,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    Center(
                      child: OutlinedButton(
                        onPressed: () {
                          List<int> list = utf8.encode(value);
                          Uint8List bytes = Uint8List.fromList(list);
                          _save.saveFile(bytes,
                              '${DateTime.now().microsecondsSinceEpoch}.png');
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))),
                        ),
                        child: const Text('Download'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      DatatableHeader(
          text: 'Title',
          value: 'title',
          show: true,
          sortable: false,
          flex: 2,
          sourceBuilder: (value, row) => Padding(
              padding: const EdgeInsets.all(8), child: SelectableText(value)),
          editable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: 'Heading',
          value: 'heading',
          show: true,
          sortable: false,
          flex: 2,
          sourceBuilder: (value, row) => Padding(
              padding: const EdgeInsets.all(5), child: SelectableText(value)),
          editable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: 'Description',
          value: 'desc',
          show: true,
          sortable: false,
          flex: 2,
          editable: true,
          sourceBuilder: (value, row) => Padding(
              padding: const EdgeInsets.all(5), child: SelectableText(value)),
          textAlign: TextAlign.left),
      DatatableHeader(
          text: 'Article Name',
          value: 'articleName',
          show: true,
          sortable: false,
          editable: true,
          sourceBuilder: (value, row) => Padding(
              padding: const EdgeInsets.all(5), child: SelectableText(value)),
          textAlign: TextAlign.left),
      DatatableHeader(
          text: 'Date',
          value: 'date',
          show: true,
          sortable: false,
          editable: false,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: 'ArticleLink',
          value: 'link',
          show: true,
          sourceBuilder: (value, row) => Padding(
              padding: const EdgeInsets.all(8), child: SelectableText(value)),
          sortable: false,
          editable: true,
          textAlign: TextAlign.left),
    ];
    _initializeData(true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('DATA TABLE'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  unawaited(Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (_) => const Dashboard())));
                },
              ),
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text('Add Campaigns'),
                onTap: () {
                  unawaited(Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                          builder: (_) => const AddCampaignPage())));
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.logout),
              //   title: const Text('Logout'),
              //   onTap: () async {
              //     await FirebaseAuth.instance.signOut().whenComplete(() => {
              //           if (currentUser == null)
              //             {
              //               unawaited(Navigator.pushReplacement(
              //                   context,
              //                   CupertinoPageRoute(
              //                       builder: (_) => const LoginPage())))
              //             }
              //           else
              //             {}
              //         });
              //   },
              // )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(0),
                constraints: const BoxConstraints(
                  maxHeight: 800,
                ),
                child: Card(
                  elevation: 1,
                  shadowColor: Colors.black,
                  clipBehavior: Clip.none,
                  child: ResponsiveDatatable(
                    title: TextButton.icon(
                      onPressed: () => {
                        unawaited(Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => const AddCampaignPage())))
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('New Campaign'),
                    ),
                    reponseScreenSizes: const [ScreenSize.xs],
                    actions: [
                      if (_isSearch)
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText:
                                  'Enter search term based on ${_searchKey!.replaceAll(RegExp('[\\W_]+'), ' ').toUpperCase()}',
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    _isSearch = false;
                                  });
                                  _initializeData();
                                },
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {},
                              ),
                            ),
                            onSubmitted: _filterData,
                          ),
                        ),
                      if (!_isSearch)
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _isSearch = true;
                            });
                          },
                        )
                    ],
                    headers: _headers,
                    source: _source,
                    selecteds: _selectedIds,
                    showSelect: _showSelect,
                    autoHeight: false,
                    // dropContainer: (data) => _DropDownContainer(data: data),
                    onChangedRow: (value, header) {
                      /// print(value);
                      /// print(header);
                    },
                    onSubmittedRow: (value, header) {
                      /// print(value);
                      /// print(header);
                    },
                    onTabRow: (data) {
                      //print(data);
                    },
                    onSort: (value) {
                      setState(() => _isLoading = true);
                      setState(() {
                        _sortColumn = value;
                        _sortAscending = !_sortAscending;
                        if (_sortAscending) {
                          _sourceFiltered.sort((a, b) =>
                              b['$_sortColumn'].compareTo(a['$_sortColumn']));
                        } else {
                          _sourceFiltered.sort((a, b) =>
                              a['$_sortColumn'].compareTo(b['$_sortColumn']));
                        }
                        var rangeTop = _currentPerPage! < _sourceFiltered.length
                            ? _currentPerPage!
                            : _sourceFiltered.length;
                        _source =
                            _sourceFiltered.getRange(0, rangeTop).toList();
                        _searchKey = value;

                        _isLoading = false;
                      });
                    },
                    expanded: _expanded,
                    sortAscending: _sortAscending,
                    sortColumn: _sortColumn,
                    isLoading: _isLoading,
                    onSelect: (value, item) {
                      //print('$value  $item ');
                      if (value!) {
                        setState(() => _selectedIds.add(item));
                      } else {
                        setState(() =>
                            _selectedIds.removeAt(_selectedIds.indexOf(item)));
                      }
                    },
                    onSelectAll: (value) {
                      if (value!) {
                        setState(() => _selectedIds =
                            _source.map((entry) => entry).toList().cast());
                      } else {
                        setState(() => _selectedIds.clear());
                      }
                    },
                    footers: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: const Text('Rows per page:'),
                      ),
                      if (_perPages.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<int>(
                            value: _currentPerPage,
                            items: _perPages
                                .map((e) => DropdownMenuItem<int>(
                                      value: e,
                                      child: Text('$e'),
                                    ))
                                .toList(),
                            onChanged: (dynamic value) {
                              setState(() {
                                _currentPerPage = value;
                                _currentPage = 1;
                                _resetData();
                              });
                            },
                            isExpanded: false,
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child:
                            Text('$_currentPage - $_currentPerPage of $_total'),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                        ),
                        onPressed: _currentPage == 1
                            ? null
                            : () {
                                var nextSet = _currentPage - _currentPerPage!;
                                setState(() {
                                  _currentPage = nextSet > 1 ? nextSet : 1;
                                  _resetData(start: _currentPage - 1);
                                });
                              },
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: _currentPage + _currentPerPage! - 1 > _total
                            ? null
                            : () {
                                var nextSet = _currentPage + _currentPerPage!;

                                setState(() {
                                  _currentPage = nextSet < _total
                                      ? nextSet
                                      : _total - _currentPerPage!;
                                  _resetData(start: nextSet - 1);
                                });
                              },
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _initializeData(true);
          },
          child: const Icon(Icons.refresh_sharp),
        ),
      );
}

class _DropDownContainer extends StatelessWidget {
  final Map<String, dynamic> data;

  const _DropDownContainer({required this.data});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = data.entries.map<Widget>((entry) {
      Widget w = Row(
        children: [
          Text(entry.key.toString()),
          const Spacer(),
          Text(entry.value.toString()),
        ],
      );
      return w;
    }).toList();

    return Column(
      children: children,
    );
  }
}
