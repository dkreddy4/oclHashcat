/**
 * Author......: Jens Steube <jens.steube@gmail.com>
 * License.....: MIT
 */

#define _MD4_

#include "include/constants.h"
#include "include/kernel_vendor.h"

#define DGST_R0 0
#define DGST_R1 3
#define DGST_R2 2
#define DGST_R3 1

#include "include/kernel_functions.c"
#include "OpenCL/types_ocl.c"
#include "OpenCL/common.c"

#define COMPARE_S "OpenCL/check_single_comp4.c"
#define COMPARE_M "OpenCL/check_multi_comp4.c"

__kernel void __attribute__((reqd_work_group_size (64, 1, 1))) m00900_m04 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 combs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * modifier
   */

  const u32 lid = get_local_id (0);

  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 wordl0[4];

  wordl0[0] = pws[gid].i[ 0];
  wordl0[1] = pws[gid].i[ 1];
  wordl0[2] = pws[gid].i[ 2];
  wordl0[3] = pws[gid].i[ 3];

  u32 wordl1[4];

  wordl1[0] = pws[gid].i[ 4];
  wordl1[1] = pws[gid].i[ 5];
  wordl1[2] = pws[gid].i[ 6];
  wordl1[3] = pws[gid].i[ 7];

  u32 wordl2[4];

  wordl2[0] = 0;
  wordl2[1] = 0;
  wordl2[2] = 0;
  wordl2[3] = 0;

  u32 wordl3[4];

  wordl3[0] = 0;
  wordl3[1] = 0;
  wordl3[2] = 0;
  wordl3[3] = 0;

  const u32 pw_l_len = pws[gid].pw_len;

  if (combs_mode == COMBINATOR_MODE_BASE_RIGHT)
  {
    append_0x80_2x4 (wordl0, wordl1, pw_l_len);

    switch_buffer_by_offset (wordl0, wordl1, wordl2, wordl3, combs_buf[0].pw_len);
  }

  /**
   * loop
   */

  for (u32 il_pos = 0; il_pos < combs_cnt; il_pos++)
  {
    const u32 pw_r_len = combs_buf[il_pos].pw_len;

    const u32 pw_len = pw_l_len + pw_r_len;

    u32 wordr0[4];

    wordr0[0] = combs_buf[il_pos].i[0];
    wordr0[1] = combs_buf[il_pos].i[1];
    wordr0[2] = combs_buf[il_pos].i[2];
    wordr0[3] = combs_buf[il_pos].i[3];

    u32 wordr1[4];

    wordr1[0] = combs_buf[il_pos].i[4];
    wordr1[1] = combs_buf[il_pos].i[5];
    wordr1[2] = combs_buf[il_pos].i[6];
    wordr1[3] = combs_buf[il_pos].i[7];

    u32 wordr2[4];

    wordr2[0] = 0;
    wordr2[1] = 0;
    wordr2[2] = 0;
    wordr2[3] = 0;

    u32 wordr3[4];

    wordr3[0] = 0;
    wordr3[1] = 0;
    wordr3[2] = 0;
    wordr3[3] = 0;

    if (combs_mode == COMBINATOR_MODE_BASE_LEFT)
    {
      switch_buffer_by_offset (wordr0, wordr1, wordr2, wordr3, pw_l_len);
    }

    u32 w0[4];

    w0[0] = wordl0[0] | wordr0[0];
    w0[1] = wordl0[1] | wordr0[1];
    w0[2] = wordl0[2] | wordr0[2];
    w0[3] = wordl0[3] | wordr0[3];

    u32 w1[4];

    w1[0] = wordl1[0] | wordr1[0];
    w1[1] = wordl1[1] | wordr1[1];
    w1[2] = wordl1[2] | wordr1[2];
    w1[3] = wordl1[3] | wordr1[3];

    u32 w2[4];

    w2[0] = wordl2[0] | wordr2[0];
    w2[1] = wordl2[1] | wordr2[1];
    w2[2] = wordl2[2] | wordr2[2];
    w2[3] = wordl2[3] | wordr2[3];

    u32 w3[4];

    w3[0] = wordl3[0] | wordr3[0];
    w3[1] = wordl3[1] | wordr3[1];
    w3[2] = pw_len * 8;
    w3[3] = 0;

    u32 a = MD4M_A;
    u32 b = MD4M_B;
    u32 c = MD4M_C;
    u32 d = MD4M_D;

    MD4_STEP (MD4_Fo, a, b, c, d, w0[0], MD4C00, MD4S00);
    MD4_STEP (MD4_Fo, d, a, b, c, w0[1], MD4C00, MD4S01);
    MD4_STEP (MD4_Fo, c, d, a, b, w0[2], MD4C00, MD4S02);
    MD4_STEP (MD4_Fo, b, c, d, a, w0[3], MD4C00, MD4S03);
    MD4_STEP (MD4_Fo, a, b, c, d, w1[0], MD4C00, MD4S00);
    MD4_STEP (MD4_Fo, d, a, b, c, w1[1], MD4C00, MD4S01);
    MD4_STEP (MD4_Fo, c, d, a, b, w1[2], MD4C00, MD4S02);
    MD4_STEP (MD4_Fo, b, c, d, a, w1[3], MD4C00, MD4S03);
    MD4_STEP (MD4_Fo, a, b, c, d, w2[0], MD4C00, MD4S00);
    MD4_STEP (MD4_Fo, d, a, b, c, w2[1], MD4C00, MD4S01);
    MD4_STEP (MD4_Fo, c, d, a, b, w2[2], MD4C00, MD4S02);
    MD4_STEP (MD4_Fo, b, c, d, a, w2[3], MD4C00, MD4S03);
    MD4_STEP (MD4_Fo, a, b, c, d, w3[0], MD4C00, MD4S00);
    MD4_STEP (MD4_Fo, d, a, b, c, w3[1], MD4C00, MD4S01);
    MD4_STEP (MD4_Fo, c, d, a, b, w3[2], MD4C00, MD4S02);
    MD4_STEP (MD4_Fo, b, c, d, a, w3[3], MD4C00, MD4S03);

    MD4_STEP (MD4_Go, a, b, c, d, w0[0], MD4C01, MD4S10);
    MD4_STEP (MD4_Go, d, a, b, c, w1[0], MD4C01, MD4S11);
    MD4_STEP (MD4_Go, c, d, a, b, w2[0], MD4C01, MD4S12);
    MD4_STEP (MD4_Go, b, c, d, a, w3[0], MD4C01, MD4S13);
    MD4_STEP (MD4_Go, a, b, c, d, w0[1], MD4C01, MD4S10);
    MD4_STEP (MD4_Go, d, a, b, c, w1[1], MD4C01, MD4S11);
    MD4_STEP (MD4_Go, c, d, a, b, w2[1], MD4C01, MD4S12);
    MD4_STEP (MD4_Go, b, c, d, a, w3[1], MD4C01, MD4S13);
    MD4_STEP (MD4_Go, a, b, c, d, w0[2], MD4C01, MD4S10);
    MD4_STEP (MD4_Go, d, a, b, c, w1[2], MD4C01, MD4S11);
    MD4_STEP (MD4_Go, c, d, a, b, w2[2], MD4C01, MD4S12);
    MD4_STEP (MD4_Go, b, c, d, a, w3[2], MD4C01, MD4S13);
    MD4_STEP (MD4_Go, a, b, c, d, w0[3], MD4C01, MD4S10);
    MD4_STEP (MD4_Go, d, a, b, c, w1[3], MD4C01, MD4S11);
    MD4_STEP (MD4_Go, c, d, a, b, w2[3], MD4C01, MD4S12);
    MD4_STEP (MD4_Go, b, c, d, a, w3[3], MD4C01, MD4S13);

    MD4_STEP (MD4_H , a, b, c, d, w0[0], MD4C02, MD4S20);
    MD4_STEP (MD4_H , d, a, b, c, w2[0], MD4C02, MD4S21);
    MD4_STEP (MD4_H , c, d, a, b, w1[0], MD4C02, MD4S22);
    MD4_STEP (MD4_H , b, c, d, a, w3[0], MD4C02, MD4S23);
    MD4_STEP (MD4_H , a, b, c, d, w0[2], MD4C02, MD4S20);
    MD4_STEP (MD4_H , d, a, b, c, w2[2], MD4C02, MD4S21);
    MD4_STEP (MD4_H , c, d, a, b, w1[2], MD4C02, MD4S22);
    MD4_STEP (MD4_H , b, c, d, a, w3[2], MD4C02, MD4S23);
    MD4_STEP (MD4_H , a, b, c, d, w0[1], MD4C02, MD4S20);
    MD4_STEP (MD4_H , d, a, b, c, w2[1], MD4C02, MD4S21);
    MD4_STEP (MD4_H , c, d, a, b, w1[1], MD4C02, MD4S22);
    MD4_STEP (MD4_H , b, c, d, a, w3[1], MD4C02, MD4S23);
    MD4_STEP (MD4_H , a, b, c, d, w0[3], MD4C02, MD4S20);
    MD4_STEP (MD4_H , d, a, b, c, w2[3], MD4C02, MD4S21);
    MD4_STEP (MD4_H , c, d, a, b, w1[3], MD4C02, MD4S22);
    MD4_STEP (MD4_H , b, c, d, a, w3[3], MD4C02, MD4S23);

    const u32 r0 = a;
    const u32 r1 = d;
    const u32 r2 = c;
    const u32 r3 = b;

    #include COMPARE_M
  }
}

__kernel void __attribute__((reqd_work_group_size (64, 1, 1))) m00900_m08 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 combs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
}

__kernel void __attribute__((reqd_work_group_size (64, 1, 1))) m00900_m16 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 combs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
}

__kernel void __attribute__((reqd_work_group_size (64, 1, 1))) m00900_s04 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 combs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * modifier
   */

  const u32 lid = get_local_id (0);

  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 wordl0[4];

  wordl0[0] = pws[gid].i[ 0];
  wordl0[1] = pws[gid].i[ 1];
  wordl0[2] = pws[gid].i[ 2];
  wordl0[3] = pws[gid].i[ 3];

  u32 wordl1[4];

  wordl1[0] = pws[gid].i[ 4];
  wordl1[1] = pws[gid].i[ 5];
  wordl1[2] = pws[gid].i[ 6];
  wordl1[3] = pws[gid].i[ 7];

  u32 wordl2[4];

  wordl2[0] = 0;
  wordl2[1] = 0;
  wordl2[2] = 0;
  wordl2[3] = 0;

  u32 wordl3[4];

  wordl3[0] = 0;
  wordl3[1] = 0;
  wordl3[2] = 0;
  wordl3[3] = 0;

  const u32 pw_l_len = pws[gid].pw_len;

  if (combs_mode == COMBINATOR_MODE_BASE_RIGHT)
  {
    append_0x80_2x4 (wordl0, wordl1, pw_l_len);

    switch_buffer_by_offset (wordl0, wordl1, wordl2, wordl3, combs_buf[0].pw_len);
  }

  /**
   * digest
   */

  const u32 search[4] =
  {
    digests_buf[digests_offset].digest_buf[DGST_R0],
    digests_buf[digests_offset].digest_buf[DGST_R1],
    digests_buf[digests_offset].digest_buf[DGST_R2],
    digests_buf[digests_offset].digest_buf[DGST_R3]
  };

  /**
   * loop
   */

  for (u32 il_pos = 0; il_pos < combs_cnt; il_pos++)
  {
    const u32 pw_r_len = combs_buf[il_pos].pw_len;

    const u32 pw_len = pw_l_len + pw_r_len;

    u32 wordr0[4];

    wordr0[0] = combs_buf[il_pos].i[0];
    wordr0[1] = combs_buf[il_pos].i[1];
    wordr0[2] = combs_buf[il_pos].i[2];
    wordr0[3] = combs_buf[il_pos].i[3];

    u32 wordr1[4];

    wordr1[0] = combs_buf[il_pos].i[4];
    wordr1[1] = combs_buf[il_pos].i[5];
    wordr1[2] = combs_buf[il_pos].i[6];
    wordr1[3] = combs_buf[il_pos].i[7];

    u32 wordr2[4];

    wordr2[0] = 0;
    wordr2[1] = 0;
    wordr2[2] = 0;
    wordr2[3] = 0;

    u32 wordr3[4];

    wordr3[0] = 0;
    wordr3[1] = 0;
    wordr3[2] = 0;
    wordr3[3] = 0;

    if (combs_mode == COMBINATOR_MODE_BASE_LEFT)
    {
      switch_buffer_by_offset (wordr0, wordr1, wordr2, wordr3, pw_l_len);
    }

    u32 w0[4];

    w0[0] = wordl0[0] | wordr0[0];
    w0[1] = wordl0[1] | wordr0[1];
    w0[2] = wordl0[2] | wordr0[2];
    w0[3] = wordl0[3] | wordr0[3];

    u32 w1[4];

    w1[0] = wordl1[0] | wordr1[0];
    w1[1] = wordl1[1] | wordr1[1];
    w1[2] = wordl1[2] | wordr1[2];
    w1[3] = wordl1[3] | wordr1[3];

    u32 w2[4];

    w2[0] = wordl2[0] | wordr2[0];
    w2[1] = wordl2[1] | wordr2[1];
    w2[2] = wordl2[2] | wordr2[2];
    w2[3] = wordl2[3] | wordr2[3];

    u32 w3[4];

    w3[0] = wordl3[0] | wordr3[0];
    w3[1] = wordl3[1] | wordr3[1];
    w3[2] = pw_len * 8;
    w3[3] = 0;

    u32 a = MD4M_A;
    u32 b = MD4M_B;
    u32 c = MD4M_C;
    u32 d = MD4M_D;

    MD4_STEP (MD4_Fo, a, b, c, d, w0[0], MD4C00, MD4S00);
    MD4_STEP (MD4_Fo, d, a, b, c, w0[1], MD4C00, MD4S01);
    MD4_STEP (MD4_Fo, c, d, a, b, w0[2], MD4C00, MD4S02);
    MD4_STEP (MD4_Fo, b, c, d, a, w0[3], MD4C00, MD4S03);
    MD4_STEP (MD4_Fo, a, b, c, d, w1[0], MD4C00, MD4S00);
    MD4_STEP (MD4_Fo, d, a, b, c, w1[1], MD4C00, MD4S01);
    MD4_STEP (MD4_Fo, c, d, a, b, w1[2], MD4C00, MD4S02);
    MD4_STEP (MD4_Fo, b, c, d, a, w1[3], MD4C00, MD4S03);
    MD4_STEP (MD4_Fo, a, b, c, d, w2[0], MD4C00, MD4S00);
    MD4_STEP (MD4_Fo, d, a, b, c, w2[1], MD4C00, MD4S01);
    MD4_STEP (MD4_Fo, c, d, a, b, w2[2], MD4C00, MD4S02);
    MD4_STEP (MD4_Fo, b, c, d, a, w2[3], MD4C00, MD4S03);
    MD4_STEP (MD4_Fo, a, b, c, d, w3[0], MD4C00, MD4S00);
    MD4_STEP (MD4_Fo, d, a, b, c, w3[1], MD4C00, MD4S01);
    MD4_STEP (MD4_Fo, c, d, a, b, w3[2], MD4C00, MD4S02);
    MD4_STEP (MD4_Fo, b, c, d, a, w3[3], MD4C00, MD4S03);

    MD4_STEP (MD4_Go, a, b, c, d, w0[0], MD4C01, MD4S10);
    MD4_STEP (MD4_Go, d, a, b, c, w1[0], MD4C01, MD4S11);
    MD4_STEP (MD4_Go, c, d, a, b, w2[0], MD4C01, MD4S12);
    MD4_STEP (MD4_Go, b, c, d, a, w3[0], MD4C01, MD4S13);
    MD4_STEP (MD4_Go, a, b, c, d, w0[1], MD4C01, MD4S10);
    MD4_STEP (MD4_Go, d, a, b, c, w1[1], MD4C01, MD4S11);
    MD4_STEP (MD4_Go, c, d, a, b, w2[1], MD4C01, MD4S12);
    MD4_STEP (MD4_Go, b, c, d, a, w3[1], MD4C01, MD4S13);
    MD4_STEP (MD4_Go, a, b, c, d, w0[2], MD4C01, MD4S10);
    MD4_STEP (MD4_Go, d, a, b, c, w1[2], MD4C01, MD4S11);
    MD4_STEP (MD4_Go, c, d, a, b, w2[2], MD4C01, MD4S12);
    MD4_STEP (MD4_Go, b, c, d, a, w3[2], MD4C01, MD4S13);
    MD4_STEP (MD4_Go, a, b, c, d, w0[3], MD4C01, MD4S10);
    MD4_STEP (MD4_Go, d, a, b, c, w1[3], MD4C01, MD4S11);
    MD4_STEP (MD4_Go, c, d, a, b, w2[3], MD4C01, MD4S12);
    MD4_STEP (MD4_Go, b, c, d, a, w3[3], MD4C01, MD4S13);

    MD4_STEP (MD4_H , a, b, c, d, w0[0], MD4C02, MD4S20);
    MD4_STEP (MD4_H , d, a, b, c, w2[0], MD4C02, MD4S21);
    MD4_STEP (MD4_H , c, d, a, b, w1[0], MD4C02, MD4S22);
    MD4_STEP (MD4_H , b, c, d, a, w3[0], MD4C02, MD4S23);
    MD4_STEP (MD4_H , a, b, c, d, w0[2], MD4C02, MD4S20);
    MD4_STEP (MD4_H , d, a, b, c, w2[2], MD4C02, MD4S21);
    MD4_STEP (MD4_H , c, d, a, b, w1[2], MD4C02, MD4S22);
    MD4_STEP (MD4_H , b, c, d, a, w3[2], MD4C02, MD4S23);
    MD4_STEP (MD4_H , a, b, c, d, w0[1], MD4C02, MD4S20);
    MD4_STEP (MD4_H , d, a, b, c, w2[1], MD4C02, MD4S21);
    MD4_STEP (MD4_H , c, d, a, b, w1[1], MD4C02, MD4S22);
    MD4_STEP (MD4_H , b, c, d, a, w3[1], MD4C02, MD4S23);
    MD4_STEP (MD4_H , a, b, c, d, w0[3], MD4C02, MD4S20);
    MD4_STEP (MD4_H , d, a, b, c, w2[3], MD4C02, MD4S21);
    MD4_STEP (MD4_H , c, d, a, b, w1[3], MD4C02, MD4S22);
    MD4_STEP (MD4_H , b, c, d, a, w3[3], MD4C02, MD4S23);

    const u32 r0 = a;
    const u32 r1 = d;
    const u32 r2 = c;
    const u32 r3 = b;

    #include COMPARE_S
  }
}

__kernel void __attribute__((reqd_work_group_size (64, 1, 1))) m00900_s08 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 combs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
}

__kernel void __attribute__((reqd_work_group_size (64, 1, 1))) m00900_s16 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 combs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
}
