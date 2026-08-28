import 'package:flutter/material.dart';
import '../../../app/status_colors.dart';

/// Stub data for the Online · IndoxHub screen. Hardcoded until the cloud
/// gateway backend lands — mirrors design/mock/tablet/models/T-models-online.html.

enum OnlineState { success, empty, firstRun, loading, error, denied }

@immutable
class OnlineProvider {
  const OnlineProvider(this.id, this.name, this.dot, this.count,
      {this.available = true});
  final String id;
  final String name;
  final Color dot;
  final int? count;
  final bool available;
}

@immutable
class OnlineModel {
  const OnlineModel({
    required this.id,
    required this.name,
    required this.providerId,
    required this.section,
    required this.icon,
    required this.ctx,
    required this.input,
    required this.output,
    required this.latency,
    required this.tput,
    required this.comment,
    this.recBadge,
    this.vision = false,
    this.tools = false,
  });
  final String id;
  final String name;
  final String providerId;
  final String section;
  final String icon;
  final String ctx;
  final String input;
  final String output;
  final String latency;
  final String tput;
  final String comment;
  final String? recBadge;
  final bool vision;
  final bool tools;
}

// Provider brand dot colors — brand identity, not theme roles.
const _green = StatusColors.success;
const _amber = StatusColors.warning;
const _blue = StatusColors.info;
const _plum = StatusColors.plum;
const _greenInk = StatusColors.successInk;
const _red = StatusColors.danger;
const _grey = StatusColors.neutral;

const onlineProviders = [
  OnlineProvider('all', 'All providers', _green, 9),
  OnlineProvider('openai', 'OpenAI', StatusColors.ember, 2),
  OnlineProvider('anthropic', 'Anthropic', _amber, 2),
  OnlineProvider('google', 'Google', _blue, 1),
  OnlineProvider('mistral', 'Mistral AI', _plum, 1),
  OnlineProvider('groq', 'Groq', _greenInk, 1),
  OnlineProvider('deepseek', 'DeepSeek', _red, 1),
  OnlineProvider('cohere', 'Cohere', _grey, null, available: false),
  OnlineProvider('xai', 'xAI', _grey, null, available: false),
];

const onlineSections = [
  ('OpenAI', 'openai/*'),
  ('Anthropic', 'anthropic/*'),
  ('Google · Mistral · Groq · DeepSeek', 'mixed/*'),
];

const onlineModels = [
  OnlineModel(
      id: 'openai/gpt-4o', name: 'GPT-4o', providerId: 'openai', section: 'OpenAI',
      icon: '⬡', ctx: '128k', input: r'$2.50', output: r'$10.00', latency: '~0.4s',
      tput: '~90', recBadge: '★ Recommended', vision: true, tools: true,
      comment: 'Flagship multimodal — strong reasoning, vision, and reliable tool calling for agents.'),
  OnlineModel(
      id: 'openai/gpt-4o-mini', name: 'GPT-4o mini', providerId: 'openai',
      section: 'OpenAI', icon: '⚡', ctx: '128k', input: r'$0.15', output: r'$0.60',
      latency: '~0.3s', tput: '~140', vision: true, tools: true,
      comment: 'Low-cost workhorse — great for high-volume classification and routing.'),
  OnlineModel(
      id: 'anthropic/claude-3-5-sonnet', name: 'Claude 3.5 Sonnet',
      providerId: 'anthropic', section: 'Anthropic', icon: '✶', ctx: '200k',
      input: r'$3.00', output: r'$15.00', latency: '~0.5s', tput: '~75',
      recBadge: '★ Recommended', vision: true, tools: true,
      comment: 'Best-in-class coding and long-document reasoning over a 200k window.'),
  OnlineModel(
      id: 'anthropic/claude-3-5-haiku', name: 'Claude 3.5 Haiku',
      providerId: 'anthropic', section: 'Anthropic', icon: '◆', ctx: '200k',
      input: r'$0.80', output: r'$4.00', latency: '~0.3s', tput: '~130', tools: true,
      comment: 'Fast and affordable — near-Sonnet quality for everyday tasks.'),
  OnlineModel(
      id: 'google/gemini-1.5-pro', name: 'Gemini 1.5 Pro', providerId: 'google',
      section: 'Google · Mistral · Groq · DeepSeek', icon: '✦', ctx: '2M',
      input: r'$1.25', output: r'$5.00', latency: '~0.6s', tput: '~65',
      recBadge: '★ Long ctx', vision: true, tools: true,
      comment: 'Enormous 2M-token context — ideal for whole-codebase analysis.'),
  OnlineModel(
      id: 'mistral/mistral-large-latest', name: 'Mistral Large', providerId: 'mistral',
      section: 'Google · Mistral · Groq · DeepSeek', icon: '🌀', ctx: '128k',
      input: r'$2.00', output: r'$6.00', latency: '~0.5s', tput: '~80', tools: true,
      comment: 'European flagship — strong reasoning and multilingual coverage.'),
  OnlineModel(
      id: 'groq/llama-3.3-70b', name: 'Llama 3.3 70B', providerId: 'groq',
      section: 'Google · Mistral · Groq · DeepSeek', icon: '🦙', ctx: '128k',
      input: r'$0.59', output: r'$0.79', latency: '~0.1s', tput: '~280',
      recBadge: '★ Very fast', tools: true,
      comment: "Open-weights Llama on Groq's LPU — one of the fastest hosted endpoints."),
  OnlineModel(
      id: 'deepseek/deepseek-chat', name: 'DeepSeek V3', providerId: 'deepseek',
      section: 'Google · Mistral · Groq · DeepSeek', icon: '🐋', ctx: '64k',
      input: r'$0.27', output: r'$1.10', latency: '~0.7s', tput: '~60',
      recBadge: '★ Cheapest', tools: true,
      comment: 'Exceptional price-to-performance — strong coding and math at the lowest cost.'),
];
