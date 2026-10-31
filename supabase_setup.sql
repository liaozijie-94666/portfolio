-- ============================================
-- 廖子杰作品集 · Supabase 在线版初始化脚本
-- 用法：Supabase 控制台 → SQL Editor → New query → 粘贴运行
-- 运行前：管理员账号 UID 已由廖子杰填入（liaozijie3899@qq.com → 7bf8369d-ba5b-4f0f-bd40-fd2208f82f1f）
-- ============================================

-- 1) 建表：单行存整份作品集数据（JSONB），key 恒为 'main'
create table if not exists public.portfolio (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  owner_id uuid not null default auth.uid(),
  updated_at timestamptz not null default now()
);

-- 2) 开启行级安全（RLS）
alter table public.portfolio enable row level security;

-- 2.5) 表级授权（RLS 策略之外的必要权限；关闭「自动曝光新表格」时不会自动生成）
grant select on public.portfolio to anon;
grant select, insert, update, delete on public.portfolio to authenticated;

-- 3) 权限策略：访客匿名只读；仅管理员本人可增 / 改 / 删
drop policy if exists "portfolio_public_read" on public.portfolio;
create policy "portfolio_public_read" on public.portfolio
  for select using (true);

drop policy if exists "portfolio_owner_insert" on public.portfolio;
create policy "portfolio_owner_insert" on public.portfolio
  for insert to authenticated
  with check (auth.uid() = owner_id);

drop policy if exists "portfolio_owner_update" on public.portfolio;
create policy "portfolio_owner_update" on public.portfolio
  for update using (auth.uid() = owner_id);

drop policy if exists "portfolio_owner_delete" on public.portfolio;
create policy "portfolio_owner_delete" on public.portfolio
  for delete using (auth.uid() = owner_id);

-- 4) 初始数据行（管理员账号创建好之后再执行本段）
insert into public.portfolio (id, data, owner_id)
values ('main', '{}'::jsonb, '7bf8369d-ba5b-4f0f-bd40-fd2208f82f1f')
on conflict (id) do nothing;

-- 5) 图片存储桶：公开读，仅管理员可上传 / 覆盖 / 删除
insert into storage.buckets (id, name, public)
values ('images', 'images', true)
on conflict (id) do nothing;

drop policy if exists "images_public_read" on storage.objects;
create policy "images_public_read" on storage.objects
  for select using (bucket_id = 'images');

drop policy if exists "images_owner_insert" on storage.objects;
create policy "images_owner_insert" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'images'
    and (select owner_id from public.portfolio where id = 'main') = auth.uid()
  );

drop policy if exists "images_owner_update" on storage.objects;
create policy "images_owner_update" on storage.objects
  for update using (
    bucket_id = 'images'
    and (select owner_id from public.portfolio where id = 'main') = auth.uid()
  );

drop policy if exists "images_owner_delete" on storage.objects;
create policy "images_owner_delete" on storage.objects
  for delete using (
    bucket_id = 'images'
    and (select owner_id from public.portfolio where id = 'main') = auth.uid()
  );
