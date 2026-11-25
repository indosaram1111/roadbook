-- 로드북 '나만 보기' 사진 저장소: Supabase > SQL Editor에 붙여넣고 Run (한 번만)

-- 비공개 저장 공간 (주소를 알아도 로그인한 본인만 열 수 있음)
insert into storage.buckets (id, name, public)
values ('photos-private', 'photos-private', false)
on conflict (id) do nothing;

-- 본인 폴더(내 사용자 ID 폴더)에서만 보기·올리기·지우기
create policy "private photos read own" on storage.objects
  for select to authenticated
  using (bucket_id = 'photos-private' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "private photos upload own" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'photos-private' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "private photos update own" on storage.objects
  for update to authenticated
  using (bucket_id = 'photos-private' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "private photos delete own" on storage.objects
  for delete to authenticated
  using (bucket_id = 'photos-private' and (storage.foldername(name))[1] = auth.uid()::text);

-- 공개 저장 공간에서 사진을 비공개로 옮길 때 원본을 내려받을 수 있도록 (이미 공개라 보기 권한만 추가)
create policy "public photos read" on storage.objects
  for select using (bucket_id = 'photos');
