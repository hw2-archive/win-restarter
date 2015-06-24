unit SLLMan;
interface

uses
  Windows;

type

   LLData = ^TLLData;
   TLLData = record
    Info: TProcessInformation;
    blocca: boolean;
   end;

  PSLLItem = ^TSLLItem;
  TSLLItem = record
    Next: pointer;
    Data: LLData;
   end;

function llsGetItem(id: cardinal; var start: PSLLItem): PSLLItem;
function llsTakeOutItem(id: cardinal; var start: PSLLItem): PSLLItem;
procedure llsInsertItem(item: PSLLItem; var start: PSLLItem);
function llsGetItemCount(start: PSLLItem): cardinal;
function llsNewSLLHeader: PSLLItem;
procedure llsKillSLLHeader(hdr: PSLLItem);
       // These ids are numbered from 0
implementation
function malloc(size: cardinal): pointer;
begin
  GetMem(result,size);
end;
function llsGetItemCount(start: pointer): cardinal;
var
  cur: PSLLItem;
  tmp: cardinal;
begin
  if start = nil then begin llsGetItemCount := 0; Exit; end;
  tmp := 1;  cur := start;
  while (cur^.Next <> nil) do
  begin
    Inc(tmp);
    cur := cur^.Next;
  end;
  llsGetItemCount := tmp;
end;
procedure llsKillSLLHeader(hdr: pointer);
begin
  if hdr = nil then Exit;
   FreeMem(hdr);
end;
function llsNewSLLHeader: PSLLItem;
var
  tmp: PSLLItem;
begin
  tmp := malloc(sizeof(TSLLItem));
  tmp^.Next := nil;
  tmp^.Data := nil;
  llsNewSLLHeader := tmp;
end;
function llsGetItem(id: cardinal; var start: pointer): pointer;
var
  cur: PSLLItem;
begin
  if start = nil then begin llsGetItem := nil; Exit; end;
  cur := start;
  while (id<>0) do
  begin
    if cur^.Next <> nil then
        begin
          Dec(id);
          cur := cur^.Next;
        end else
        begin
          llsGetItem := nil;
          Exit;
        end;
  end;
  llsGetItem := cur;
end;

function llsTakeOutItem(id: cardinal; var start: pointer): pointer;
var
  tmp: PSLLItem;
  last: PSLLItem;
begin
  if start = nil then begin llsTakeOutItem := nil; Exit; end;
  if (id = 0) then
    begin
      tmp := start;
      if tmp^.Next = nil then start := nil else start := tmp^.Next;
      llsTakeOutItem := tmp;
      Exit;
    end;
  tmp := start;
  repeat
    dec(id);
    last := tmp;
    tmp := tmp^.Next;
  until (id = 0);
  last^.Next := tmp^.Next;
  llsTakeOutitem := tmp;
end;
procedure llsInsertItem(item: PSLLItem; var start: PSLLItem);
var
  cur: PSLLItem;
begin
 if start = nil then
  begin
    start := item;
    exit;
  end;
 cur := start;
 while (cur^.Next<>nil) do cur := cur^.Next;
 cur^.Next := item;
end;

end.

