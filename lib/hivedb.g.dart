// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hivedb.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchKeywordAdapter extends TypeAdapter<SearchKeyword> {
  @override
  final int typeId = 0;

  @override
  SearchKeyword read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchKeyword()..name = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, SearchKeyword obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchKeywordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
