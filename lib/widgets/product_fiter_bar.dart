import 'dart:async';

import 'package:app/helpers/constants.dart';
import 'package:app/models/brand.dart';
import 'package:app/models/session.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

typedef OnSearchChanged = void Function(String query);
typedef OnSortSelected = void Function(String sortOption);
typedef OnPriceRangeSelected = void Function(double? min, double? max);
typedef OnClearAll = void Function();

class ProductFilterBar extends StatefulWidget {
  final OnSearchChanged onSearchChanged;
  final OnSortSelected onSortSelected;
  final OnPriceRangeSelected? onPriceRangeSelected;
  final OnClearAll? onClearAll;
  final String? hintText;
  final double debounceMilliseconds;
  final List<Brand>? brands;
  final String? selectedBrand;
  final void Function(String?)? onBrandSelected;
  final double? minPrice;
  final double? maxPrice;
  final bool? backButton;

  const ProductFilterBar({
    super.key,
    required this.onSearchChanged,
    required this.onSortSelected,
    this.onPriceRangeSelected,
    this.onClearAll,
    this.hintText,
    this.debounceMilliseconds = 600,
    this.brands,
    this.selectedBrand,
    this.minPrice,
    this.maxPrice,
    this.onBrandSelected,
    this.backButton = false,
  });

  @override
  State<ProductFilterBar> createState() => _ProductFilterBarState();
}

class _ProductFilterBarState extends State<ProductFilterBar> {
  final ScrollController _scrollCtrl = ScrollController();
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String? _selectedSort;
  double? _minPrice;
  double? _maxPrice;

  ProductViewType _viewType = ProductViewType.grid;

  @override
  void initState() {
    super.initState();
    final stored = Session.get<String>(SessionKey.productViewType);
    if (stored == ProductViewType.list.name) {
      _viewType = ProductViewType.list;
    }
    _minPrice = widget.minPrice;
    _maxPrice = widget.maxPrice;
  }

  void _toggleViewType() {
    setState(() {
      _viewType = _viewType == ProductViewType.grid
          ? ProductViewType.list
          : ProductViewType.grid;
    });
    Session.set(SessionKey.productViewType, _viewType.name);
    widget.onSortSelected('view:${_viewType.name}');
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      Duration(milliseconds: widget.debounceMilliseconds.toInt()),
      () => widget.onSearchChanged(value),
    );
  }

  void _toggleSort(String value) {
    setState(() {
      if (_selectedSort == value) {
        _selectedSort = null;
      } else {
        _selectedSort = value;
      }
    });
    widget.onSortSelected(_selectedSort ?? '');
  }

  // 🧩 Brand bottom sheet
  void _openBrandSheet() {
    if (widget.brands == null || widget.brands!.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  'اختر العلامة التجارية',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.brands!.length,
                  itemBuilder: (context, index) {
                    final brand = widget.brands![index];
                    final isSelected =
                        widget.selectedBrand == brand.id.toString();
                    return ListTile(
                      leading: brand.image != null
                          ? CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(brand.image!),
                            )
                          : const Icon(Icons.store, size: 20),
                      title: Text(
                        brand.name,
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.blue)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        widget.onBrandSelected?.call(brand.id.toString());
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // 💰 Price range bottom sheet
  void _openPriceSheet() {
    final minController = TextEditingController(
      text: _minPrice?.toString() ?? '',
    );
    final maxController = TextEditingController(
      text: _maxPrice?.toString() ?? '',
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تصفية حسب السعر',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'السعر الأدنى',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: maxController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'السعر الأعلى',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final min = double.tryParse(minController.text);
                          final max = double.tryParse(maxController.text);
                          Navigator.pop(context);
                          setState(() {
                            _minPrice = min;
                            _maxPrice = max;
                          });
                          widget.onPriceRangeSelected?.call(min, max);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('تطبيق'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _clearAll() {
    setState(() {
      _selectedSort = null;
      _minPrice = null;
      _maxPrice = null;
    });
    widget.onBrandSelected?.call(null);
    widget.onPriceRangeSelected?.call(null, null);
    widget.onSortSelected('');
    widget.onClearAll?.call();
  }

  bool get _hasFilters =>
      _selectedSort != null ||
      widget.selectedBrand != null ||
      _minPrice != null ||
      _maxPrice != null;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      {
        'key': 'min_price',
        'label': 'أقل سعر',
        'icon': LucideIcons.banknoteArrowDown300,
      },
      {'key': 'newest', 'label': 'الأحدث', 'icon': LucideIcons.clock3},
      {'key': 'rating', 'label': 'الأعلى تقييم', 'icon': LucideIcons.star},
      {'key': 'a_to_z', 'label': 'تصاعدي', 'icon': LucideIcons.arrowUpAZ300},
      {'key': 'z_to_a', 'label': 'تنازلي', 'icon': LucideIcons.arrowDownZA300},
      {
        'key': 'max_price',
        'label': 'أعلى سعر',
        'icon': LucideIcons.banknoteArrowUp300,
      },
      {'key': 'oldest', 'label': 'الأقدم', 'icon': LucideIcons.clock1},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        children: [
          Container(
            color: Constants.scaffoldBackgroundColor,
            padding: const EdgeInsets.all(10),
            child: Row(
              spacing: 5,
              children: [
                if (widget.backButton == true)
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: TextField(
                      controller: _controller,
                      onChanged: _onTextChanged,
                      decoration: InputDecoration(
                        hintText: widget.hintText ?? 'بحث...',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _toggleViewType,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 45,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      _viewType == ProductViewType.grid
                          ? LucideIcons.list300
                          : LucideIcons.grip300,
                      size: 22,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              spacing: 6,
              children: [
                // Brand
                if (widget.brands?.isNotEmpty ?? false)
                  InkWell(
                    onTap: _openBrandSheet,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Constants.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.tag300, size: 16),
                          const SizedBox(width: 5),
                          Text('الماركة', style: const TextStyle(fontSize: 12)),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                InkWell(
                  onTap: _openPriceSheet,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 120,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Constants.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.banknote300, size: 16),
                        SizedBox(width: 5),
                        Text('السعر', style: TextStyle(fontSize: 12)),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                ...sortOptions.map((opt) {
                  final isActive = _selectedSort == opt['key'];
                  return GestureDetector(
                    onTap: () => _toggleSort(opt['key']! as String),
                    child: AnimatedContainer(
                      width: 120,
                      alignment: Alignment.center,
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.blueAccent
                            : Constants.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Icon(
                            opt['icon']! as IconData,
                            size: 16,
                            color: isActive ? Colors.white : Colors.black54,
                          ),
                          Text(
                            opt['label']! as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: isActive ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          if (_hasFilters)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                spacing: 6,
                children: [
                  if (widget.selectedBrand != null)
                    _buildTag(
                      label:
                          'ماركة: ${widget.brands?.firstWhere((b) => b.id.toString() == widget.selectedBrand, orElse: () => Brand(id: 0, name: 'غير معروف')).name}',
                      onRemove: () => widget.onBrandSelected?.call(null),
                    ),
                  if (_minPrice != null || _maxPrice != null)
                    _buildTag(
                      label: 'السعر: ${_minPrice ?? 0} - ${_maxPrice ?? "∞"}',
                      onRemove: () {
                        setState(() {
                          _minPrice = null;
                          _maxPrice = null;
                        });
                        widget.onPriceRangeSelected?.call(null, null);
                      },
                    ),
                  if (_selectedSort != null)
                    _buildTag(
                      label:
                          'الترتيب: ${sortOptions.firstWhere((s) => s['key'] == _selectedSort)['label']}',
                      onRemove: () => _toggleSort(_selectedSort!),
                    ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _clearAll,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'مسح',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTag({required String label, required VoidCallback onRemove}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14),
          ),
        ],
      ),
    );
  }
}
